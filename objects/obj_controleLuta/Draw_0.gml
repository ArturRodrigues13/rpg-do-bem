draw_text(0, 0, $"Action counter: {battle.actionCounter}");

var baq = battle.actionQueue;
if (!baq.isEmpty()) {
	var a = baq.peek();
	
	switch (a[0]) {
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
