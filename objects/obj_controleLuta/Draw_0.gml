if (array_length(menu_stack) > 0) {
	array_last(menu_stack).onDraw();	
}

draw_text(300, 50, (turno_atual == Turno.ALIADOS) ? "TURNO ALIADO" : "TURNO INIMIGO");

if (estado_atual == estado.ITEM) {
	var _x = room_width;
	var _y = room_height;

	draw_set_colour(c_green);
	draw_rectangle(0, _y - 100, _x, _y, false);
	draw_set_colour(c_white);
	
	for (var i = 0; i < array_length(global.inventario); i++) {
		draw_text(40 + 20 * i, _y - 70, global.inventario[i].nome);
		if (indice_item == i) {
			draw_sprite(spr_setinha, 0, 30 + 20 * i, _y - 70);
		}
	}
}
