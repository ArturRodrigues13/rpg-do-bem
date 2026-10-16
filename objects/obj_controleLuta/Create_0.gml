enum Turno { ALIADOS, INIMIGOS }
turno_atual = Turno.ALIADOS;

enum estado {
	ESCOLHENDO,
	ATACAR,
	ITEM,
	FUGIR
}

estado_atual = estado.ESCOLHENDO;
menu_stack = [];
last_enemy_idx = 0;
indice_aliados = 0;

setInimigos(global.partyInimiga, global.info);
setAliados(global.partyAliada);

function Menu(_stack, _ctl) constructor {
	stack = _stack;
	control = _ctl;
	choices = [];
	choice_idx = 0;
	
	onStep = function() {
		handleInput();
		choice_idx = clamp(choice_idx, 0, array_length(choices) - 1);
	}
	
	onDraw = function() {
		var _x = room_width;
		var _y = room_height;
		
		draw_set_colour(c_green);
		draw_rectangle(0, _y - 100, _x, _y, false);
		draw_set_colour(c_white);
	
		for (var i = 0; i < array_length(choices); i++) {		
			draw_text(40, _y - 70 + 20 * i, choices[i]);
		
			if (choice_idx == i) {
				draw_sprite(spr_setinha, 0, 30, _y - 70 + 20 * i);
			}
		}
	}
	
	handleInput = function() {
		if (keyboard_check_pressed(global.keys.up)) choice_idx--;
		if (keyboard_check_pressed(global.keys.down)) choice_idx++;
		choice_idx = clamp(choice_idx, 0, array_length(choices) - 1);
		
		if (keyboard_check_pressed(global.keys.confirm)) onChoice();
		if (keyboard_check_pressed(global.keys.back)) array_pop(stack); 
	}
	
	onChoice = function() {
		show_error("not implemented", true);
	}
}

function AttackTargetMenu(_stack, _ctl) : Menu(_stack, _ctl) constructor {
	choices = global.partyInimiga;
	choice_idx = clamp(_ctl.last_enemy_idx, 0, array_length(choices));
	
	getEnemyPos = function() {
		if (choice_idx < 0 || choice_idx >= array_length(choices))
			return arrowTargetPos;
		
		var e = choices[choice_idx];
		return [e.x - 20, e.y];
	}
	
	arrowTargetPos = getEnemyPos();
	arrowPos = arrowTargetPos;
	
	onStep = function() {
		choice_idx = clamp(choice_idx, 0, array_length(choices));
		arrowTargetPos = getEnemyPos();
		// arrowPos = VecLerp(arrowPos, arrowTargetPos, 0.475);
		arrowPos[0] = lerp(arrowPos[0], arrowTargetPos[0], 0.475);
		arrowPos[1] = lerp(arrowPos[1], arrowTargetPos[1], 0.475);
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
			draw_text(e.x + 30, e.y, $"Vida: {e.defs.vida}");
		}

		draw_sprite(spr_setinha, 0, arrowPos[0], arrowPos[1]);
	}
	
	handleInput = function() {
		if (keyboard_check_pressed(global.keys.back)) {
			array_pop(stack);
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
		var aliado_atacante = global.partyAliada[control.indice_aliados];
		Ataque(aliado_atacante, global.partyInimiga, choice_idx);
		choice_idx = clamp(choice_idx, 0, array_length(global.partyInimiga));
		control.indice_aliados++;

		if (control.indice_aliados == array_length(global.partyAliada)) {
			control.indice_aliados = 0;
			control.turno_atual = Turno.INIMIGOS;
		}
		array_pop(stack);
	}
}

function ChoiceMenu(_stack, _ctl) : Menu(_stack, _ctl) constructor {
	choices = ["ATACAR", "ITEM", "FUGIR"];
	
	onChoice = function() {
		if (choice_idx == 0) {
			// FIXME: ...??? não não era assim não
			array_pop(stack);
			array_push(stack, new control.AttackTargetMenu(stack, control));
		} else if (choice_idx == 1) {
			control.estado_atual = estado.ITEM;
		} else {	
			game_end();
		}
	}
}