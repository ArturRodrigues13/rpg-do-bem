if (turno_atual == Turno.ALIADOS) {
	if (mstack.isEmpty()) {
		mstack.push(new ChoiceMenu(mstack, self));
	}
	mstack.peek().onStep();
} else if (turno_atual == Turno.INIMIGOS) {
	if (keyboard_check_pressed(global.keys.confirm)) {
		turno_atual = Turno.ALIADOS; 
		checkStatus(global.partyAliada, global.partyInimiga);
	}
}