global.itensData = {
	pocaodeVida: {
		name: "Vida",
		desc: "cura (o amigo, forever big cloba)",
		spr: spr_pocaoVida,
		targetScope: TargetScope.ALLY_SINGLE,
		onUse: function(_target) {
			_target.defs.vida += 20;
		}
	},
	
	pedra: {
		name: "Pedra",
		desc: "taca pedra NO INIMIGO E EXECUTA\nELE DE FORMA BRUTAL",
		spr: spr_pedra,
		targetScope: TargetScope.ENEMY_SINGLE,
		onUse: function(_target) {
			Dano(10, _target, DamageType.PHYSICAL);
		}
	},
	
	boladeFogo: {
		name: "Fogo",
		desc: "Nuke",
		spr: spr_bolaFogo,
		targetScope: TargetScope.ENEMY_ALL,
		onUse: function(_target) {
			DanoAll(999, global.battle.enemies, DamageType.TRUTH);
		}
	}
}

function addItem(_itemID) {
	checkInvFirstEmptySpace();
	
	if (global.invFirstEmptySpace == -1) {
		show_debug_message("inventário cheio viadinho");
		return;
	}
	
	global.inventory[global.invFirstEmptySpace] = _itemID;
	show_debug_message("pegou :)");
}

function checkInvFirstEmptySpace() {
	for (var i = 0; i < array_length(global.inventory); i++) {
		if (global.inventory[i] == undefined) {
			global.invFirstEmptySpace = i;
			return;
		}
	}
	
	global.invFirstEmptySpace = -1;
	return;
}