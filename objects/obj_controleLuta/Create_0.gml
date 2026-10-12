enum turno {
	
	ALIADOS,
	INIMIGOS
}

atacantes = turno.ALIADOS;

indice = 0;

alvo = 0;

infoInimiga = [];

instance_create_layer(50, 300, "Instances", obj_player);

setInimigos(global.partyInimiga, global.info);