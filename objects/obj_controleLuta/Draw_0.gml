if (array_length(menu_stack) > 0) {
	array_last(menu_stack).onDraw();	
}

if (turno_atual == Turno.ALIADOS) {
	draw_text(300, 50, "TURNO ALIADO");
} else {
	draw_text(300, 50, "TURNO INIMIGO");
}