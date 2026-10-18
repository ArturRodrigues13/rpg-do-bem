if (!mstack.isEmpty()) {
	mstack.peek().onDraw();
}

draw_text(room_width / 2, 50, (turno_atual == Turno.ALIADOS) ? "TURNO ALIADO" : "TURNO INIMIGO");