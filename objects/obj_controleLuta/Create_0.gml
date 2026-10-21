turno_atual = Turno.ALIADOS;

mstack = new MenuStack();
lastAttackIdx = 0;
allyIdx = 0;
indice_item = 0;

setInimigos(global.partyInimiga, global.enemiesInfo);
setAliados(global.partyAliada);

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
/// @param {obj_controleLuta} _cl
function Menu(_stack, _cl) constructor {
	stack = _stack;
	cl = _cl;
	choices = [];
	choiceIdx = 0;
	
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

		if (keyboard_check_pressed(_gk.up)) choiceIdx--;
		if (keyboard_check_pressed(_gk.down)) choiceIdx++;
		choiceIdx = clamp(choiceIdx, 0, array_length (choices) - 1);
		
		if (keyboard_check_pressed(_gk.confirm)) onChoice();
		if (keyboard_check_pressed(_gk.back)) stack.pop();
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

function ChoiceMenu(_stack, _cl) : Menu(_stack, _cl) constructor {
	choices = ["ATACAR", "ITEM", "FUGIR"];
	
	onChoice = function() {
		if (choiceIdx == 0) {
			stack.push(new cl.TargetMenu(stack, cl, {
				action: TargetAction.ATTACK,
				targetType: TargetScope.EnemySingle,
			}));
		} else if (choiceIdx == 1) {
			stack.push(new cl.ItemMenu(stack, cl));
		} else {	
			global.partyAliada = [];
			global.partyInimiga = [];
			room_goto(rm_teste);
		}
	}
}

function TargetMenu(_stack, _cl, _args) : Menu(_stack, _cl) constructor {
	// args é um de:
	//   { action: TargetAction.ATTACK }
	//   { action: TargetAction.ITEM, itemInfo: <info do item>, itemIdx: int }
	args = _args;
	
	choices = (args.targetType == TargetScope.AllyAll || args.targetType == TargetScope.AllySingle)
		? global.partyAliada
		: global.partyInimiga;
	
	// TODO: fazer funcionar com aliados tbm né...
	
	choiceIdx = clamp(_cl.lastAttackIdx, 0, array_length(choices));
	
	getTargetPos = function() {
		if (choiceIdx < 0 || choiceIdx >= array_length(choices))
			return arrowTargetPos;
		
		var e = choices[choiceIdx];
		return [e.x - 20, e.y];
	}
	
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
			draw_text(al.x - 30, al.y, $"Vida: {al.defs.vida}");
		}

		var inimigos = global.partyInimiga;
		for (var i = 0; i < array_length(inimigos); i++) {
			var e = inimigos[i];
			draw_text(e.x - 30, e.y, $"Vida: {e.defs.vida}");
		}

		draw_sprite(spr_setinha, 0, arrowPos[0], arrowPos[1]);
	}
	
	handleInput = function() {
		if (keyboard_check_pressed(global.keys.back)) {
			stack.pop();
		} else if (keyboard_check_pressed(global.keys.confirm)) {
			onChoice();
		} else {		
			var dir = [
				keyboard_check_pressed(global.keys.right) - keyboard_check_pressed(global.keys.left),
				keyboard_check_pressed(global.keys.down) - keyboard_check_pressed(global.keys.up),
			];
			if (dir != [0, 0]) tryChangeTarget(dir);
		}
	}
	
	// TODO: tirar essa miséria
	tryChangeTarget = function(_dir) {
		var inimigos = global.enemiesInfo;
		if (array_length(inimigos) == 0) return;
		choiceIdx = clamp(choiceIdx, 0, array_length(inimigos) - 1);
		var posAtual = inimigos[choiceIdx].pos;
		var cand = [];
	
		for (var i = 0; i < array_length(inimigos); i++) {
			if (i == choiceIdx) continue;
		
			var ii = inimigos[i];
			var dp = VecDotNormalized(VecSub(ii.pos, posAtual), _dir);
			if (dp >= 0.25) array_push(cand, { dot: dp, idx: i, pos: ii.pos });
		}
		array_sort(cand, function(_a, _b) { return sign(_a.dot - _b.dot); });
	
		if (array_length(cand) == 0) return;
	
		var maiorDot = array_last(cand).dot;
		var menorDist = VecDist(posAtual, array_last(cand).pos);
		var maisProx = array_length(cand) - 1;
		for (var i = array_length(cand) - 2; i > 0 && cand[i].dot == maiorDot; i--) {
			var dist = VecDist(posAtual, cand[i].pos);
			if (dist < menorDist) {
				menorDist = dist;
				maisProx = i;
			}
		}
	
		choiceIdx = cand[maisProx].idx;
	}

	onChoice = function() {
		switch (args.action) {
			case TargetAction.ATTACK:
				cl.lastAttackIdx = choiceIdx;
				var aliado_atacante = global.partyAliada[cl.allyIdx];
				Ataque(aliado_atacante, global.partyInimiga, choiceIdx);
				choiceIdx = clamp(choiceIdx, 0, array_length(global.partyInimiga));
				break;
			case TargetAction.ITEM:
				var itemAtual = args.itemInfo;
				itemAtual.uso(global.partyInimiga[choiceIdx]);
				global.inventario[args.itemIdx] = noone;
				checkLastEmptySpace();
				break;
			default:
				show_debug_message("fuck");
		}

		cl.allyIdx++;

		if (cl.allyIdx == array_length(global.partyAliada)) {
			cl.allyIdx = 0;
			cl.turno_atual = Turno.INIMIGOS;
		}

		stack.confirmAndPop(noone);
	}
}

function ItemMenu(_stack, _cl) : Menu(_stack, _cl) constructor {
	choices = global.inventario;
	
	onDraw = function() {
		var _x = room_width;
		var _y = room_height;
		
		var _xsqr = 83;
		var _ysqr = 9;
		var _distx = 0;
		var _disty = 0;
		var _size = 40;
		
		// offset matemático, poderia fazer a conta aqui mas ia dar trabalho, chatão
		var _offsetx = 19.5;
		var _offsety = 4;
		
		draw_set_alpha(.7);
		draw_set_colour(c_black);
		draw_rectangle(0,0, _x, _y, false);
		draw_set_alpha(1);
		
		draw_set_colour(c_orange);
		draw_rectangle(80, 5, _x - 80, _y - 75, false);
		draw_set_colour(c_white);
		
		for (var i = 0; i < 12; i ++) {
			
			if (i == choiceIdx) draw_set_colour(c_green);
			draw_rectangle(_xsqr, _ysqr, _xsqr + _size, _ysqr + _size, true);
			draw_set_colour(c_white);
			
			if (choices[choiceIdx] != noone) {
				draw_set_colour(c_green);
				draw_rectangle(10, _y - 64, _x - 10, _y - 5, false);
				draw_set_colour(c_white);
				
				draw_text(15, _y - 60, choices[choiceIdx].nome);
				draw_text(15, _y - 45, choices[choiceIdx].descricao);
			}
			
			if (choices[i] != noone) {
				draw_sprite(choices[i].spr, 0, _xsqr + _size / 2, _ysqr + _size / 2)
			}
			
			_ysqr += _size + _offsety;

			if (i mod 3 == 2) {
				_ysqr = 9;
				_xsqr += _size + _offsetx;
			}
		}
	}
	
	handleInput = function() {
		var _gk = global.keys;

		if (keyboard_check_pressed(_gk.up) && choiceIdx mod 3 != 0) choiceIdx--;
		if (keyboard_check_pressed(_gk.down) && choiceIdx mod 3 != 2) choiceIdx++;
		if (keyboard_check_pressed(_gk.left) && choiceIdx > 2) choiceIdx -= 3;
		if (keyboard_check_pressed(_gk.right) && choiceIdx < 9) choiceIdx += 3;	
		choiceIdx = clamp(choiceIdx, 0, 11);
		
		if (keyboard_check_pressed(_gk.confirm) && choices[choiceIdx] != noone) onChoice();
		if (keyboard_check_pressed(_gk.back)) stack.pop();
	}

	onChoice = function() {
		if (array_length(choices) == 0) return;

		stack.push(new cl.TargetMenu(stack, cl, {
			action: TargetAction.ITEM,
			targetType: choices[choiceIdx].alvo,
			itemInfo: choices[choiceIdx],
			itemIdx: choiceIdx,
		}));
	}
}