global.battleMenuData = {
	lastAttackIdx: 0,
};

function MenuStack() constructor {
	stack = [];
	
	/// @param {Menu} _menu O menu a ser adicionado
	push = function(_menu) {
		array_push(stack, _menu);
	}
	
	pop = function() {
		return array_pop(stack);
	}
	
	peek = function() {
		return array_last(stack);
	}

	isEmpty = function() {
		return array_length(stack) == 0;
	}

	/// @desc Tira o menu atual da pilha e passa `_data` para o pai, se presente.
	confirmAndPop = function(_data) {
		pop();
		if (!isEmpty()) {
			peek().onConfirmSignal(_data);
		}
	}
}

/// @param {MenuStack} _stack
function Menu(_stack) constructor {
	stack = _stack;
	choices = [];
	choiceIdx = 0;
	allowBack = true;
	
	onStep = function() {
		handleInput();
		choiceIdx = clamp(choiceIdx, 0, array_length(choices) - 1);
	}
	
	onDraw = function() {
		var _x = room_width;
		var _y = room_height;
		
		draw_set_colour(c_green);
		draw_rectangle(0, _y - 50, _x, _y, false);
		draw_set_colour(c_white);
	
		for (var i = 0; i < array_length(choices); i++) {		
			draw_text(40, _y - 70 + 20 * i, choices[i]);
		
			if (choiceIdx == i) {
				draw_sprite(spr_setinha, 0, 30, _y - 60 + 20 * i);
			}
		}
	}
	
	handleInput = function() {
		var _gk = global.keys;

		if (_gk.up.isPressed()) choiceIdx--;
		if (_gk.down.isPressed()) choiceIdx++;
		choiceIdx = clamp(choiceIdx, 0, array_length(choices) - 1);
		
		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.back.isPressed() && allowBack) stack.pop();
	}
	
	onChoice = function() {
		show_error("not implemented", true);
	}
	
	/// @param {Any} _data Informação
	/// @desc Roda quando um sinal
	onConfirmSignal = function(_data) {
		// Nessa implementação padrão, não fazer nada; só tirar da pilha e sinalizar pro pai.
		stack.confirmAndPop();
	}
}

function ChoiceMenu(_stack) : Menu(_stack) constructor {
	choices = ["ATAQUE", "FEITIÇO", "ITEM", "FUGIR"];
	allowBack = false;
	
	onChoice = function() {
		if (choiceIdx == 0) {
			stack.push(new ActionMenu(stack, {
				type: ActionType.ATTACK
			}));
		} else if (choiceIdx == 1) {
			stack.push(new ActionMenu(stack, {
				type: ActionType.SPELL
			}));
		} else if (choiceIdx == 2) {
			stack.push(new ItemMenu(stack));
		} else {
			// TODO: fazer um mecanismo p/ voltar para a sala anterior à batalha
			global.partyAliada = [];
			global.partyInimiga = [];
			room_goto(rm_teste);
		}
	}
}

function ActionMenu(_stack, _args) : Menu(_stack) constructor { 
	
	battle = global.battle;
	
	var allyActions = battle.allies[battle.allyIdx].defs.actions;
	
	choices = [];
	for (var i = 0; i < array_length(allyActions); i++) {
	    var ac = allyActions[i];
	    if (ac.type == _args.type) array_push(choices, ac);
	}
	
	onDraw = function() {
		var _x = room_width;
		var _y = room_height;
		
		draw_set_colour(c_green);
		draw_rectangle(0, _y - 50, _x, _y, false);
		draw_set_colour(c_white);
	
		for (var i = 0; i < array_length(choices); i++) {
					
			draw_text(40, _y - 70 + 20 * i, choices[i].name);
		
			if (choiceIdx == i) {
				draw_sprite(spr_setinha, 0, 30, _y - 60 + 20 * i);
				
				draw_text(120, _y - 70, choices[i].desc);
			}
		}
	}
	
	onChoice = function() {
		stack.push(new TargetMenu(stack, {
			action: TargetAction.ACTION,
			actionInfo: choices[choiceIdx],
			targetType: choices[choiceIdx].targetType
		}));
	}
} 

function TargetMenu(_stack, _args) : Menu(_stack) constructor {
	// Args pode ser:
	// - { action: TargetAction.ACTION, actionInfo: <info da action> }
	// - { action: TargetAction.ITEM, itemInfo: <info do item>, itemIdx: int }
	args = _args;
	bmd = global.battleMenuData;
	battle = global.battle;
	
	isSingleTarget = (args.targetType == TargetScope.EnemySingle || args.targetType == TargetScope.AllySingle);
	isAllyTarget = (args.targetType == TargetScope.AllyAll || args.targetType == TargetScope.AllySingle);

	ncols = 2;
	choices = isAllyTarget ? global.partyAliada : global.partyInimiga;
	choiceIdx = clamp(bmd.lastAttackIdx, 0, array_length(choices));
	
	// @desc Calcula a posição de destino para um target.
	getTargetPos = function() {
		// essa função nem faz sentido para multi-target
		if (!isSingleTarget) return arrowTargetPos;
		
		if (choiceIdx < 0 || choiceIdx >= array_length(choices))
			return arrowTargetPos;
		
		var e = choices[choiceIdx];
		return [e.x - 20, e.y];
	}
	
	arrowTargetPos = [0, 0]; // para evitar problemas caso for lido enquanto chama `getTargetPos`
	arrowTargetPos = getTargetPos();
	arrowPos = arrowTargetPos;
	
	onStep = function() {
		choiceIdx = clamp(choiceIdx, 0, array_length(choices));
		arrowTargetPos = getTargetPos();
		arrowPos = VecLerp(arrowPos, arrowTargetPos, 0.475);
		handleInput();
	}
	
	onDraw = function() {
		
		var aliados = global.partyAliada;
		for (var i = 0; i < array_length(aliados); i++) {
			var al = aliados[i];
			draw_text(al.x - 30, al.y, $"Vida:{al.defs.vida}");
		}

		var inimigos = global.partyInimiga;
		for (var i = 0; i < array_length(inimigos); i++) {
			var e = inimigos[i];
			draw_text(e.x - 30, e.y, $"Vida:{e.defs.vida}");
		}
		
		switch (args.targetType) {
			case TargetScope.AllySingle:
			case TargetScope.EnemySingle:
				draw_sprite(spr_setinha, 0, arrowPos[0], arrowPos[1]);
				break;
				
			case TargetScope.AllyAll:
				for (var i = 0; i < array_length(aliados); i++) {
					var _o = aliados[i];
					draw_sprite(spr_setinha, 0, _o.x - 20, _o.y);
				}
				break;
				
			case TargetScope.EnemyAll:
				for (var i = 0; i < array_length(inimigos); i++) {
					var _o = inimigos[i];
					draw_sprite(spr_setinha, 0, _o.x - 20, _o.y);
				}
				break;
		}
	}
	
	handleInput = function() {
		var _gk = global.keys;

		if (_gk.back.isPressed()) {
			stack.pop();
		} else if (_gk.confirm.isPressed()) {
			onChoice();
		} else {		
			var _dir = [
				_gk.right.isPressed() - _gk.left.isPressed(),
				_gk.down.isPressed() - _gk.up.isPressed(),
			];
			if (_dir != [0, 0]) changeTarget(_dir);
		}
	}
	
	/// @desc Tenta alterar a escolha com base em um vetor de direção.
	changeTarget = function(_dir) {
		var infos = choices;
		if (array_length(infos) == 0) return;

		var _nrows = ceil(array_length(infos) / ncols);

		var _x = choiceIdx mod ncols;
		_x = clamp(_x + _dir[0], 0, ncols - 1);

		var _y = choiceIdx div ncols;
		_y = clamp(_y + _dir[1], 0, _nrows - 1);

		choiceIdx = clamp(_y * ncols + _x, 0, array_length(infos) - 1);
	}

	onChoice = function() {
		switch (args.action) {
			case TargetAction.ACTION:
				var _target = global.partyInimiga[choiceIdx];
				if (_target.defs.isDown()) {
					// TODO: tocar sfx de "escolha invalida" :))
					return;
				}
				bmd.lastAttackIdx = choiceIdx;
				var attackingAlly = global.partyAliada[battle.allyIdx];
				args.actionInfo.onUse(_target, attackingAlly);
				
				choiceIdx = clamp(choiceIdx, 0, array_length(global.partyInimiga));
				break;
			case TargetAction.ITEM:
				var _currentItem = args.itemInfo;
				
				if (args.targetType == TargetScope.EnemySingle) {
					_target = global.partyInimiga[choiceIdx];
					if (_target.defs.isDown()) {
						// TODO: tocar sfx de "escolha invalida" :))
						return;
					}
					_currentItem.uso(_target);
				} else if(args.targetType == TargetScope.EnemyAll) {
					_currentItem.uso(global.partyInimiga);
				} else if(args.targetType == TargetScope.AllySingle) {
					_target = global.partyAliada[choiceIdx];
					if (_target.defs.isDown()) {
						// TODO: tocar sfx de "escolha invalida" :))
						return;
					}
					_currentItem.uso(_target);
				} else {
					_currentItem.uso(global.partyAliada);
				}
				
				global.inventario[args.itemIdx] = undefined;
				break;
			default:
				show_error($"UNKNOWN TARGET ACTION {args.action}", false);
		}
		
		// desenfileirar a ação do player atual
		battle.actionQueue.dequeue();
		
		stack.confirmAndPop(undefined);
	}
}

function ItemMenu(_stack) : Menu(_stack) constructor {
	choices = global.inventario;
	ncols = 4;
	//nlins = ceil(array_length(choices) / ncols);
	
	onDraw = function() {
		var _rw = room_width;
		var _rh = room_height;

		
		// Fundo preto opaco
		draw_set_alpha(.7);
		draw_set_colour(c_black);
		draw_rectangle(0, 0, _rw, _rh, false);
		draw_set_alpha(1);
		draw_set_colour(c_white);
		
		var _originX = 108;
		var _originY = 29;
		var _offX = 56;
		var _offY = 42;
		
		draw_sprite(spr_inventory, choiceIdx, 80, 5);
		
		for (var i = 0; i < 12; i++) {
			
			var ix = i mod ncols;
			var iy = i div ncols;
			
			var _leftX = _originX + ix * _offX;
			var _topY = _originY + iy * _offY;
			
			if (choices[i] != undefined) {
				var itemInfo = global.itensData[$ choices[i]];
				draw_sprite(itemInfo.spr, 0, _leftX, _topY);
			}
		}
		
		if (choices[choiceIdx] != undefined) {
			var itemInfo = global.itensData[$ choices[choiceIdx]];
			draw_set_colour(c_green);
			draw_rectangle(10, _rh - 64, _rw - 10, _rh - 5, false);
			draw_set_colour(c_white);
			
			draw_text(15, _rh - 60, itemInfo.nome);
			draw_text(15, _rh - 45, itemInfo.descricao);
		}
	}
	
	handleInput = function() {
		var _gk = global.keys;
		var _dimX = 4;
		var _dimY = 3;
		var _dirX = _gk.right.isPressed() - _gk.left.isPressed();
		var _dirY = _gk.down.isPressed() - _gk.up.isPressed();
		var _x = clamp((choiceIdx mod _dimX) + _dirX, 0, _dimX - 1);
		var _y = clamp((choiceIdx div _dimX) + _dirY, 0, _dimY - 1);
		choiceIdx = _y * _dimX + _x;
		
		if (_gk.confirm.isPressed() && choices[choiceIdx] != undefined) onChoice();
		if (_gk.back.isPressed()) stack.pop();
	}

	onChoice = function() {
		var itemInfo = global.itensData[$ choices[choiceIdx]];
		stack.push(new TargetMenu(stack, {
			action: TargetAction.ITEM,
			targetType: itemInfo.alvo,
			itemInfo: itemInfo,
			itemIdx: choiceIdx,
		}));
	}
}
