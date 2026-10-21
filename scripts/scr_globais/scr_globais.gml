randomise();

// Combate

global.partyAliada = [];
global.partyInimiga = [];
global.inventario = array_create(12, noone);
global.lastEmptySpace = 0;

global.info = [];

enum tipoAlvo {
	
	ALIADOUNICO,
	ALIADOS,
	INIMIGOUNICO,
	INIMIGOS
}

global.keys = {
	
	down: vk_down,
	up: vk_up,
	left: vk_left,
	right: vk_right,
	confirm: vk_enter,
	back: vk_escape
}
