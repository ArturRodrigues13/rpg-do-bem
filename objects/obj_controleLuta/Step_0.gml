if (turno_atual == Turno.ALIADOS) {
	if (mstack.isEmpty()) {
		mstack.push(new ChoiceMenu(mstack, self));
	}
	mstack.peek().onStep();
} else if (turno_atual == Turno.INIMIGOS) {
	if (keyboard_check_pressed(global.keys.confirm)) {
		estado_atual = estado.ESCOLHENDO;
		turno_atual = Turno.ALIADOS; 
	}
}

if (array_length(global.partyInimiga) == 0) game_end();