randomise();

// Combate

global.partyAliada = [];
global.partyInimiga = [];
global.itemAtual = noone;
global.inventario = [];

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