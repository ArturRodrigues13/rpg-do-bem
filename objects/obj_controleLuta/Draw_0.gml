var baq = battle.actionQueue;

battle.drawBattleInfo();

if (!baq.isEmpty()) {
	var a = baq.peek();

	switch (a.source) {
		case "moment":
			break;
		case "enemy":
			break;
		case "ally":
			if (!mstack.isEmpty()) {
				mstack.peek().onDraw();
			}
			break;
		default:
			show_error("???", true);
	}
}