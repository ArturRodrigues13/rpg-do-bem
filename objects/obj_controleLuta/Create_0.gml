enum Turno { ALIADOS, INIMIGOS }
turno_atual = Turno.ALIADOS;

enum estado {
	ESCOLHENDO,
	ATACAR,
	ITEM,
	FUGIR
}

mstack = new MenuStack();
estado_atual = estado.ESCOLHENDO;
last_enemy_idx = 0;
indice_aliados = 0;
indice_item = 0;

setInimigos(global.partyInimiga, global.info);
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
	choice_idx = 0;
	item = false;
	targetType = noone;
	
	onStep = function() {
		handleInput();
		choice_idx = clamp(choice_idx, 0, array_length(choices) - 1);
	}
	
	onDraw = function() {
		var _x = room_width;
		var _y = room_height;
		
		draw_set_colour(c_green);
		draw_rectangle(0, _y - 50, _x, _y, false);
		draw_set_colour(c_white);
	
		for (var i = 0; i < array_length(choices); i++) {		
			draw_text(40, _y - 70 + 20 * i, choices[i]);
		
			if (choice_idx == i) {
				draw_sprite(spr_setinha, 0, 30, _y - 60 + 20 * i);
			}
		}
	}
	
	handleInput = function() {
		var gk = global.keys;

		if (keyboard_check_pressed(gk.up)) choice_idx--;
		if (keyboard_check_pressed(gk.down)) choice_idx++;
		choice_idx = clamp(choice_idx, 0, array_length (choices) - 1);
		
		if (keyboard_check_pressed(gk.confirm)) onChoice();
		if (keyboard_check_pressed(gk.back)) stack.pop();
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
		if (choice_idx == 0) {
			stack.push(new cl.AttackTargetMenu(stack, cl, false, tipoAlvo.INIMIGOUNICO));
		} else if (choice_idx == 1) {
			stack.push(new cl.ItemMenu(stack, cl));
		} else {	
			game_end();
		}
	}
}

function AttackTargetMenu(_stack, _cl, _item, _targetType) : Menu(_stack, _cl) constructor {
	
	targeType = _targetType;
	item = _item;
	
	if(targeType == tipoAlvo.ALIADOS || targeType == tipoAlvo.ALIADOUNICO) {
		
		choices = global.partyAliada;
	} else {
		
		choices = global.partyInimiga;
	}
	
	choice_idx = clamp(_cl.last_enemy_idx, 0, array_length(choices));
	
	getTargetPos = function() {
		if (choice_idx < 0 || choice_idx >= array_length(choices))
			return arrowTargetPos;
		
		var e = choices[choice_idx];
		return [e.x - 20, e.y];
	}
	
	arrowTargetPos = getTargetPos();
	arrowPos = arrowTargetPos;
	
	onStep = function() {
		choice_idx = clamp(choice_idx, 0, array_length(choices));
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
	
	tryChangeTarget = function(_dir) {
		var inimigos = global.info;
		if (array_length(inimigos) == 0) return;
		choice_idx = clamp(choice_idx, 0, array_length(inimigos) - 1);
		var posAtual = inimigos[choice_idx].pos;
		var cand = [];
	
		for (var i = 0; i < array_length(inimigos); i++) {
			if (i == choice_idx) continue;
		
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
	
		choice_idx = cand[maisProx].idx;
	}

	onChoice = function() {
		if(item == false) {
			
			var aliado_atacante = global.partyAliada[cl.indice_aliados];
			Ataque(aliado_atacante, global.partyInimiga, choice_idx);
			choice_idx = clamp(choice_idx, 0, array_length(global.partyInimiga));
		} else {
			
			global.itemAtual[0].uso(global.partyInimiga[choice_idx]);
			
			array_insert(global.inventario, global.itemAtual[1], noone);
			array_delete(global.inventario, global.itemAtual[1] + 1, 1);
		}
		
		cl.indice_aliados++;
		
		if (cl.indice_aliados == array_length(global.partyAliada)) {
			
			cl.indice_aliados = 0;
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
		
		var _xsqr = 68;
		var _ysqr = 28;
		var _distx = 0;
		var _disty = 0;
		var _size = 45;
		var _offsetx = 22.5;
		var _offsety = 12.5;
		
		// 12.5 e 22.6 é o offset matemático, poderia fazer a conta aqui mas ia dar trabalho, chatão
		
		draw_set_colour(c_orange);
		draw_rectangle(60, 20, _x - 60, _y - 20, false);
		draw_set_colour(c_white);
		
		for(var i = 0; i < 12; i ++) {
			
			if(i == choice_idx) draw_set_colour(c_green);
			draw_rectangle(_xsqr, _ysqr, _xsqr + _size, _ysqr + _size, true);
			draw_set_colour(c_white);
			
			if(choices[i] != noone) {
				
				draw_sprite(choices[i].spr, 0, _xsqr + _size / 2, _ysqr + _size / 2)
			}
			
			_ysqr += _size + _offsety;

			if(i mod 3 == 2) {
				_ysqr = 28;
				_xsqr += _size + _offsetx;
			}
		}
	}
	
	handleInput = function() {
		var gk = global.keys;

		if (keyboard_check_pressed(gk.up) && choice_idx mod 3 != 0) choice_idx--;
		if (keyboard_check_pressed(gk.down) && choice_idx mod 3 != 2) choice_idx++;
		if (keyboard_check_pressed(gk.left) && choice_idx > 2) choice_idx -= 3; 
		if (keyboard_check_pressed(gk.right) && choice_idx < 9) choice_idx += 3;	
		choice_idx = clamp(choice_idx, 0, 11);
		
		if (keyboard_check_pressed(gk.confirm) && choices[choice_idx] != noone) onChoice();
		if (keyboard_check_pressed(gk.back)) stack.pop();
	}

	onChoice = function() {
		if (array_length(choices) == 0) return;

		global.itemAtual = [choices[choice_idx], choice_idx];
		stack.push(new cl.AttackTargetMenu(stack, cl, true, global.itemAtual[0].alvo));
	}
}