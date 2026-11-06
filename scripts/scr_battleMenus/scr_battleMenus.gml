global.battleMenuData = {
	lastAttackIdx: 0,
};

function ChoiceMenu(_stack) : Menu(_stack) constructor {
	choices = ["ATAQUE", "HABILIDADE", "ITEM", "CHECK", "FUGIR"];
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
		} else if (choiceIdx == 3) {
			show_debug_message("checa inimigos: niba!")
		} else {
			// TODO: fazer um mecanismo p/ voltar para a sala anterior à batalha
			global.battle = undefined;
			room_goto(rm_teste);
		}
	}
	
	onDraw = function() {
		
		draw_sprite(spr_choiceMenu,0, 0, room_height - 75);
		var txtX = 30;
		var txtY = room_height - 65;


		for (var i = 0; i < array_length(choices); i++) {
			var offsetX = (i == 4) ? 132 : (room_width - 110) * (i mod 2);
			var offsetY = (i == 4) ? 40 : 30 * (i div 2);
			
			draw_text(txtX + offsetX, txtY + offsetY, choices[i]);

			if (choiceIdx == i) {
				draw_sprite(spr_setinha, 0, txtX + offsetX - 10, txtY + offsetY + 10);
			}
		}
	}
	
	handleInput = function() {
		var _gk = global.keys;

		if (_gk.up.isPressed()) choiceIdx -= 2;
		if (_gk.down.isPressed()) choiceIdx += 2; 
		if (_gk.right.isPressed()) choiceIdx = choiceIdx != 4 ? choiceIdx+1 : choiceIdx-1;
		if (_gk.left.isPressed()) choiceIdx = choiceIdx != 4 ? choiceIdx-1 : choiceIdx-2;
		choiceIdx = clamp(choiceIdx, 0, array_length(choices) - 1);

		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.back.isPressed() && allowBack) stack.pop();
	}
}

function ActionMenu(_stack, _args) : Menu(_stack) constructor {
	battle = global.battle;
	args = _args;
	stack = _stack;
	firstOpAvailable = 0;
	lastOpAvailable = firstOpAvailable + 2;
	attackingAllyDefs = battle.allies[battle.allyIdx].defs;
	
	var allyActions = attackingAllyDefs.actions;

	choices = [];
	for (var i = 0; i < array_length(allyActions); i++) {
	    var ac = allyActions[i];
	    if (ac.type == args.type) array_push(choices, ac);
	}
	
	arraySize = array_length(choices);

	onDraw = function() {
		
		var subimg = args.type == ActionType.ATTACK ? 0 : 1
		
		draw_sprite(spr_actionMenu, subimg, 0, room_height - 75)
		
		if(arraySize == 0) return;
		
		var txtNameX = 25;
		var txtNameY = room_height - 70;
		var txtDescY = room_height - 75;
		var txtDescX = 160;
		var offsetTextY = 20;

		for (var i = 0; i < 3; i++) {
			
			if(i >= arraySize) continue;
				
			if(choices[firstOpAvailable + i].cost > attackingAllyDefs.energy) draw_set_colour(c_red);
			draw_text(txtNameX, txtNameY + offsetTextY * i, choices[firstOpAvailable + i].name);
			draw_set_colour(c_white);
			
			if (choiceIdx == firstOpAvailable + i) {
				draw_sprite(spr_setinha, 0, txtNameX - 10, txtNameY + offsetTextY * i + 10);
			}
		}
		
		var currentChoice = choices[choiceIdx];
		var iconsOriginX = args.type == ActionType.ATTACK ? 172 : 163;
		var iconsOriginY = room_height - 21;
		var offsetIconsX = args.type == ActionType.ATTACK ? 77 : 58;
		
		draw_text_ext(txtDescX, txtDescY, currentChoice.desc, 16, 216);
		
		var dIcon = getDamageIcon(currentChoice.damageType);
		var eIcon = getElementIcon(currentChoice.element);
		var tIcon = getTargetIcon(currentChoice.targetScope);
		
		draw_sprite(dIcon, 0, iconsOriginX, iconsOriginY);
		draw_sprite(eIcon, 0, iconsOriginX + offsetIconsX, iconsOriginY);
		draw_sprite(tIcon, 0, iconsOriginX + offsetIconsX * 2, iconsOriginY);
		if(args.type == ActionType.SPELL) {
			draw_sprite(spr_energyIcon, 0, iconsOriginX + offsetIconsX * 3, iconsOriginY);
			draw_text(iconsOriginX + offsetIconsX * 3 + 15, iconsOriginY - 3, string(currentChoice.cost));
		}
	}
	
	handleInput = function() {
		var _gk = global.keys;

		if (_gk.up.isPressed()) choiceIdx--;
		if (_gk.down.isPressed()) choiceIdx++;
		choiceIdx = clamp(choiceIdx, 0, array_length(choices) - 1);

		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.back.isPressed() && allowBack) stack.pop();
			
		if(choiceIdx > lastOpAvailable) {
			firstOpAvailable++;
			lastOpAvailable++;
		} else if (choiceIdx < firstOpAvailable) {
			firstOpAvailable--;
			lastOpAvailable--;
		}
	}

	onChoice = function() {
		
		if(array_length(choices) == 0) return;
			
		if(choices[choiceIdx].cost > attackingAllyDefs.energy) {
			// TODO: tocar sfx de "escolha invalida" :))
			return;
		}
		
		stack.push(new TargetMenu(stack, {
			actionType: args.type,
			actionInfo: choices[choiceIdx],
			targetScope: choices[choiceIdx].targetScope
		}));
	}
}

function TargetMenu(_stack, _args) : Menu(_stack) constructor {
	// Args pode ser:
	// - { actionType: ActionType.ACTION, targetScope: <escopo do alvo>, actionInfo: <info da action> }
	// - { actionType: ActionType.ITEM, targetScope: <escopo do alvo>, itemInfo: <info do item>, itemIdx: int }
	args = _args;
	bmd = global.battleMenuData;
	battle = global.battle;

	isSingleTarget = (args.targetScope == TargetScope.ENEMY_SINGLE || args.targetScope == TargetScope.ALLY_SINGLE);
	isAllyTarget = (args.targetScope == TargetScope.ALLY_ALL || args.targetScope == TargetScope.ALLY_SINGLE);

	ncols = 2;
	choices = isAllyTarget ? battle.allies : battle.enemies;
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
		var aliados = battle.allies;
		for (var i = 0; i < array_length(aliados); i++) {
			var al = aliados[i];
			draw_text(al.x - 30, al.y, $"Vida:{al.defs.vida}");
		}

		var inimigos = battle.enemies;
		for (var i = 0; i < array_length(inimigos); i++) {
			var e = inimigos[i];
			draw_text(e.x - 30, e.y, $"Vida:{e.defs.vida}");
		}

		switch (args.targetScope) {
			case TargetScope.ALLY_SINGLE:
			case TargetScope.ENEMY_SINGLE:
				draw_sprite(spr_setinha, 0, arrowPos[0], arrowPos[1]);
				break;

			case TargetScope.ALLY_ALL:
				for (var i = 0; i < array_length(aliados); i++) {
					var _o = aliados[i];
					draw_sprite(spr_setinha, 0, _o.x - 20, _o.y);
				}
				break;

			case TargetScope.ENEMY_ALL:
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
		
		var target = undefined;
		
		if(isSingleTarget) {
			if(isAllyTarget) {
				target = battle.allies[choiceIdx];
			} else {
				target = battle.enemies[choiceIdx];
			}
			
			
			if (target.defs.isDown()) {
				// TODO: tocar sfx de "escolha invalida" :))
				return;
			}
		}
		
		var attackingAlly = battle.allies[battle.allyIdx];
		
		switch (args.actionType) {
			
			case ActionType.ATTACK:
			case ActionType.SPELL:
				
				bmd.lastAttackIdx = choiceIdx;
				args.actionInfo.onUse(target, attackingAlly);
				attackingAlly.defs.energy -= args.actionInfo.cost;

				choiceIdx = clamp(choiceIdx, 0, array_length(battle.enemies));
				break;
			
			case ActionType.ITEM:
				
				var _currentItem = args.itemInfo;
				
				_currentItem.onUse(target);

				global.inventory[args.itemIdx] = undefined;
				break;
			
			default:
				show_error($"UNKNOWN TARGET ACTION {args.actionType}", false);
		}

		// desenfileirar a ação do player atual
		battle.actionQueue.dequeue();

		stack.confirmAndPop(undefined);
	}
}

function ItemMenu(_stack) : Menu(_stack) constructor {
	choices = global.inventory;
	ncols = 4;

	onDraw = function() {
		var _rw = room_width;
		var _rh = room_height;

		// Fundo preto opaco
		draw_set_alpha(.7);
		draw_set_colour(c_black);
		draw_rectangle(0, 0, _rw, _rh, false);
		draw_set_alpha(1);
		draw_set_colour(c_white);
		
		var invX = 80;
		var invY = 15;

		draw_sprite(spr_inventory, choiceIdx, invX, invY);
		
		var originX = invX + 28;
		var originY = invY + 24;
		var offX = 56;
		var offY = 42;

		for (var i = 0; i < 12; i++) {

			var ix = i mod ncols;
			var iy = i div ncols;

			var _leftX = originX + ix * offX;
			var _topY = originY + iy * offY;

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

			draw_text(15, _rh - 60, itemInfo.name);
			draw_text(15, _rh - 45, itemInfo.desc);
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
			actionType: ActionType.ITEM,
			targetScope: itemInfo.targetScope,
			itemInfo: itemInfo,
			itemIdx: choiceIdx,
		}));
	}
}
