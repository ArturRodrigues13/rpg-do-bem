if (turno_atual == Turno.ALIADOS) {
	if (estado_atual == estado.ESCOLHENDO) {
		if (array_length(menu_stack) == 0) {
			array_push(menu_stack, new ChoiceMenu(menu_stack, self));
		}
		array_last(menu_stack).onStep();
	} else if (estado_atual == estado.ATACAR) {
		if (array_length(menu_stack) == 0) {
			estado_atual = estado.ESCOLHENDO;
		} else {
			array_last(menu_stack).onStep();
		}
	} else if (estado_atual == estado.ITEM) {
		if (keyboard_check_pressed(global.keys.back)) {
			estado_atual = estado.ESCOLHENDO;
		}
	}
} else if (turno_atual == Turno.INIMIGOS) {
	if (keyboard_check_pressed(global.keys.confirm)) {
		estado_atual = estado.ESCOLHENDO;
		turno_atual = Turno.ALIADOS; 
	}
}

if (array_length(global.partyInimiga) == 0) game_end();