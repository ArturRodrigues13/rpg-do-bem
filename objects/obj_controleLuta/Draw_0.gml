if (array_length(menu_stack) > 0) {
	array_last(menu_stack).onDraw();	
}

draw_text(room_width / 2, 50, (turno_atual == Turno.ALIADOS) ? "TURNO ALIADO" : "TURNO INIMIGO");