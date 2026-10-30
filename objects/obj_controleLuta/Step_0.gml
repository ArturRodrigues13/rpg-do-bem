battle.stepBattleTime();

var baq = battle.actionQueue;
if (!baq.isEmpty()) {
	var a = baq.peek();
	
	switch (a[0]) {
		case "moment":
			checkStatus(battle.allies, battle.enemies);
			baq.dequeue();
			break;
		case "enemy":
			show_debug_message("INIMIGO ATACA NOVAMENTE");
			dumbAttack(battle.allies, battle.enemies[a[1]]);
			show_message("buft");
			baq.dequeue();
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
