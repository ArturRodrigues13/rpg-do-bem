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
			baq.dequeue();
			break;
		case "ally":
			
			if(battle.allies[a[1]].defs.isDown()) {
				baq.dequeue();
				break;
			} 
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
