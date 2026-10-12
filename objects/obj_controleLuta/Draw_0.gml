var inimigos = global.partyInimiga;

for(var i = 0; i < array_length(inimigos); i++) {
	
	draw_text(inimigos[i].x + 30, inimigos[i].y, "Vida: " + string(inimigos[i].atributos.vida));
}

if(atacantes == turno.ALIADOS) {

	draw_sprite(spr_setinha, 0, inimigos[alvo].x - 20, inimigos[alvo].y)
	draw_text(300, 50, "TURNO ALIADO");
	
} else {
	
	draw_text(300, 50, "TURNO INIMIGO");
}


