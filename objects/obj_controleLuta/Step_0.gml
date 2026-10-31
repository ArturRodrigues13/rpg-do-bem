battle.stepBattleTime();

var baq = battle.actionQueue;
if (!baq.isEmpty()) {
	var a = baq.peek();
	switch (a.source) {
		case "moment":
			checkStatus(battle.allies, battle.enemies);
			baq.dequeue();
			break;
		case "enemy":
			show_debug_message("INIMIGO ATACA NOVAMENTE");
			battle.enemyRandomAction(battle.enemies[a.idx]);
			baq.dequeue();
			break;
		case "ally":
			if (battle.allies[a.idx].defs.isDown()) {
				baq.dequeue();
				break;
			}
			battle.allyIdx = a.idx;
			if (mstack.isEmpty()) {
				mstack.push(new ChoiceMenu(mstack));
			}
			mstack.peek().onStep();
			break;
		default:
			show_error("???", true);
	}
}
