randomise();

#region Enums

/// @desc Escopo de uma ação.
enum TargetScope {
	ALLY_SINGLE,
	ALLY_ALL,
	ENEMY_SINGLE,
	ENEMY_ALL,
	SELF
}

enum ActionType {
	ATTACK,
	SPELL,
	ITEM
}

enum DamageType {
	PHYSICAL,
	MAGIC,
	TRUTH,
	NOONE
}

enum Element {
	FIRE,
	WATER,
	WIND,
	EARTH,
	ELECTRICAL,
	NATURE,
	MACHINE,
	HOLY,
	UNHOLY,
	_MAX,
}

#endregion



// Combate
global.inventory = array_create(12, undefined);
global.invFirstEmptySpace = 0;
global.invHeldItem = undefined;

global.allyData = {
	knight0: {
		obj: obj_cavaleiro,
	},
	mage0: {
		obj: obj_mago,
	},
	sup: {
		obj: obj_sup,
	},
};

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
	inventory: new KeyHandler([ord("I")]),
};

// TODO: salvar e carregar configurações de keybindings

#endregion

// TODO: onde bota isso kkkkkkkkkkk
function arraySortStableExt(_array, _cmp=undefined) {
	var cmp = (_cmp != undefined) ? _cmp : function(_a, _b) {
		if (_a < _b) return -1;
		if (_a > _b) return 1;
		return 0;
	};

	var len = array_length(_array);
	for (var i = 0; i < len; i++) {
		var swapped = false;
		for (var j = 0; j < len - i - 1; j++) {
			if (cmp(_array[j], _array[j+1])) {
				var tmp = _array[j+1];
				_array[j+1] = _array[j];
				_array[j] = tmp;
				swapped = true;
			}
		}
		if (swapped) break;
	}
}
