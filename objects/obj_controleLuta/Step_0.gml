battle.stepBattleTime();

var baq = battle.actionQueue;
if (!baq.isEmpty()) {
	var a = baq.peek();
	switch (a.source) {
		case "moment":
			checkStatus(battle.battleInstances);
			baq.dequeue();
			break;
		case "enemy":
			var enemyD = battle.battleInstances[a.idx].defs;
			if(enemyD.isDown() or enemyD.skipAction) {
				enemyD.skipAction = false;
			} else {
				battle.enemyRandomAction(battle.battleInstances[a.idx]);
			}
			
			baq.dequeue();
			break;
		case "ally":
			var allyD = battle.battleInstances[a.idx].defs;
			if (allyD.skipAction) {
				allyD.skipAction = false;
				baq.dequeue();
			} else {
				battle.allyIdx = a.idx;
				if (mstack.isEmpty()) {
					mstack.push(new ChoiceMenu(mstack));
				}
				mstack.peek().onStep();
			}
			
			break;
		default:
			show_error("???", true);
	}
}
