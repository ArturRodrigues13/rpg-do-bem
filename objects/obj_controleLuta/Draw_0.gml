var inimigos = global.partyInimiga;
var aliado = global.partyAliada;

var _x = room_width;
var _y = room_height;

if(estado_atual == escolha.ESCOLHENDO) {
	
	draw_set_colour(c_green);
	draw_rectangle(0, _y - 100, _x, _y, false);
	draw_set_colour(c_white);
	
	for(var i = 0; i < array_length(opcoes); i++) {
		
		draw_text(40, _y - 70 + 20 * i, opcoes[i]);
		
		if(indice_escolha == i) {
			
			draw_sprite(spr_setinha, 0, 30, _y - 70 + 20 * i);
		}
	}
	
} else if(estado_atual == escolha.ATACAR) {

	for(var i = 0; i < array_length(aliado); i++) {
	
		draw_text(aliado[i].x - 30, aliado[i].y, "Vida: " + string(aliado[i].atributos.vida));
	}

	for(var i = 0; i < array_length(inimigos); i++) {
	
		draw_text(inimigos[i].x + 30, inimigos[i].y, "Vida: " + string(inimigos[i].atributos.vida));
	}

	if(atacantes == turno.ALIADOS) {

		draw_sprite(spr_setinha, 0, inimigos[alvo].x - 20, inimigos[alvo].y)
		draw_text(300, 50, "TURNO ALIADO");
	
	} else {
	
		draw_text(300, 50, "TURNO INIMIGO");
	}
}