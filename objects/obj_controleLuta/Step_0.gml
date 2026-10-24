if (turno_atual == Turno.ALIADOS) {
	if (mstack.isEmpty()) {
		mstack.push(new ChoiceMenu(mstack, self));
	}
	mstack.peek().onStep();
} else if (turno_atual == Turno.INIMIGOS) {
	if (global.keys.confirm.isPressed()) {
		turno_atual = Turno.ALIADOS;
		checkStatus(global.partyAliada, global.partyInimiga);
	}
}
