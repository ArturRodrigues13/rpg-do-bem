var inimigos = global.partyInimiga;
var aliado = global.partyAliada;

var _x = room_width;
var _y = room_height;

if(estado_atual == estado.ESCOLHENDO) {
	
	draw_set_colour(c_green);
	draw_rectangle(0, _y - 100, _x, _y, false);
	draw_set_colour(c_white);
	
	for(var i = 0; i < array_length(opcoes); i++) {
		
		draw_text(40, _y - 70 + 20 * i, opcoes[i]);
		
		if(indice_escolha == i) {
			
			draw_sprite(spr_setinha, 0, 30, _y - 70 + 20 * i);
		}
	}
	
} else if(estado_atual == estado.ATACAR) {

	for(var i = 0; i < array_length(aliado); i++) {
	
		draw_text(aliado[i].x - 30, aliado[i].y, "Vida: " + string(aliado[i].defs.vida));
	}

	for(var i = 0; i < array_length(inimigos); i++) {
	
		draw_text(inimigos[i].x + 30, inimigos[i].y, "Vida: " + string(inimigos[i].defs.vida));
	}

	if(atacantes == turno.ALIADOS) {

		draw_sprite(spr_setinha, 0, setinhaX, setinhaY);
		draw_text(300, 50, "TURNO ALIADO");
	
	} else {
	
		draw_text(300, 50, "TURNO INIMIGO");
	}
} else if(estado_atual == estado.ITEM) {
	
	draw_set_colour(c_green);
	draw_rectangle(0, _y - 100, _x, _y, false);
	draw_set_colour(c_white);
	
	for(var i = 0; i < array_length(global.inventario); i++) {
		
		draw_text(40 + 20 * i, _y - 70, global.inventario[i].nome);
		
		if(indice_item == i) {
			
			draw_sprite(spr_setinha, 0, 30 + 20 * i, _y - 70);
		}
	}
}