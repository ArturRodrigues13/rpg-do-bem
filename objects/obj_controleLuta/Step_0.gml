battle.stepBattleTime();

if (battle.hasPendingAction()) {
	var a = battle.getPendingAction();
	
	switch (a[0]) {
		case "moment":
			checkStatus(battle.allies, battle.enemies);
			battle.dequeuePendingAction();
			break;
		case "enemy":
			show_debug_message("INIMIGO ATACA NOVAMENTE");
			battle.dequeuePendingAction();
			break;
		case "ally":
			battle.allyIdx = a[1];
			if (mstack.isEmpty()) {
				mstack.push(new ChoiceMenu(mstack));
			}
			mstack.peek().onStep();
			break;
		default:
			show_error("???", true);
	}
}