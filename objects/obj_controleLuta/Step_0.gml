var _battle = global.battle;

if (_battle.turnoAtual == Turno.ALIADOS) {
	if (mstack.isEmpty()) {
		mstack.push(new ChoiceMenu(mstack));
	}
	mstack.peek().onStep();
} else if (_battle.turnoAtual == Turno.INIMIGOS) {
	if (global.keys.confirm.isPressed()) {
		_battle.turnoAtual = Turno.ALIADOS;
		checkStatus(global.partyAliada, global.partyInimiga);
	}
}
