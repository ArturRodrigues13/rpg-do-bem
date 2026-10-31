randomise();

#region Enums

/// @desc Escopo de uma ação.
enum TargetScope {
	ALLY_SINGLE,
	ALLY_ALL,
	ENEMY_SINGLE,
	ENEMY_ALL,
}

enum ActionType {
	ATTACK,
	SPELL
}

enum TargetAction {
	ACTION,
	ITEM,
}

enum DamageType {
	PHYSICAL,
	MAGIC,
	TRUTH
}

enum Element {
	FIRE,
	WATER,
	WIND,
	EARTH
}

enum Type {
	VAMPIRE
}

#endregion

// Combate
global.inventario = array_create(12, undefined);
global.invFirstEmptySpace = 0;
global.enemiesInfo = [];

#region Keybindings

function KeyHandler(_keys) constructor {
	keys = _keys;
	isPressed = function() { return array_any(keys, keyboard_check_pressed); }
	isHeld = function() { return array_any(keys, keyboard_check); }
}

global.keys = {
	down: new KeyHandler([vk_down]),
	up: new KeyHandler([vk_up]),
	left: new KeyHandler([vk_left]),
	right: new KeyHandler([vk_right]),
	confirm: new KeyHandler([vk_enter, ord("Z")]),
	back: new KeyHandler([vk_escape, ord("X")]),
};

// TODO: salvar e carregar configurações de keybindings

#endregion
