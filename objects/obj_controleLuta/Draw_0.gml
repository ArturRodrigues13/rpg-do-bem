var baq = battle.actionQueue;

battle.drawStepBattleProgressBar();

if (!baq.isEmpty()) {
	var a = baq.peek();

	switch (a.source) {
		case "moment":
			break;
		case "enemy":
			break;
		case "ally":
			var ally = battle.allies[a.idx];
			draw_sprite(spr_suaVezMano, 0, ally.x, ally.y + 16);
			if (!mstack.isEmpty()) {
				mstack.peek().onDraw();
			}
			break;
		default:
			show_error("???", true);
	}
}
