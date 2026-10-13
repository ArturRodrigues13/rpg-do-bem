enum turno {
	
	ALIADOS,
	INIMIGOS
}

enum escolha {
	
	ESCOLHENDO,
	ATACAR,
	ITEM
}

atacantes = turno.ALIADOS; 
estado_atual = escolha.ESCOLHENDO;
opcoes = ["ATACAR", "ITEM"];

indice_escolha = 0;
indice_aliados = 0;
alvo = 0;

infoInimiga = [];

setAliados(global.partyAliada);

setInimigos(global.partyInimiga, global.info);