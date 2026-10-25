if (turnoAtual == Turno.ALIADOS) {
	if (mstack.isEmpty()) {
		mstack.push(new ChoiceMenu(mstack, self));
	}
	mstack.peek().onStep();
} else if (turnoAtual == Turno.INIMIGOS) {
	if (global.keys.confirm.isPressed()) {
		turnoAtual = Turno.ALIADOS;
		checkStatus(global.partyAliada, global.partyInimiga);
	}
}
