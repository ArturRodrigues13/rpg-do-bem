randomise();

// Combate
global.partyAliada = [];
global.partyInimiga = [];
global.inventario = array_create(12, noone);
global.lastEmptySpace = 0;
global.enemiesInfo = [];

global.keys = {
	down: vk_down,
	up: vk_up,
	left: vk_left,
	right: vk_right,
	confirm: vk_enter,
	back: vk_escape
}

enum TargetScope {
	AllySingle,
	AllyAll,
	EnemySingle,
	EnemyAll,
}

enum TargetAction {
	ATTACK,
	ITEM,
}

enum Turno { 
	ALIADOS, 
	INIMIGOS,  
}


