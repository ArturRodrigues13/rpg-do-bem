//draw_text(0, 0, $"Action counter: {battle.actionCounter}");

var baq = battle.actionQueue;

battle.drawStepBattleProgressBar();

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
			
			draw_sprite(spr_suaVezMano, 0, battle.allies[a[1]].x, battle.allies[a[1]].y + 16);
			break;
		default:
			show_error("???", true);
	}
}
