global.itensData = {
	pocaodeVida: {
		nome: "Vida",
		descricao: "cura (o amigo, forever big cloba)",
		spr: spr_pocaoVida,
		alvo: TargetScope.AllySingle,
		uso: function(_alvo) {
			_alvo.defs.vida += 20;
		}
	},
	
	pedra: {
		nome: "Pedra",
		descricao: "taca pedra NO INIMIGO E EXECUTA\nELE DE FORMA BRUTAL",
		spr: spr_pedra,
		alvo: TargetScope.EnemySingle,
		uso: function(_alvo) {
			Dano(10, _alvo, DamageType.PHYSICAL);
		}
	},
	
	boladeFogo: {
		nome: "Fogo",
		descricao: "Nuke",
		spr: spr_bolaFogo,
		alvo: TargetScope.EnemyAll,
		uso: function(_alvos) {
			DanoAll(999, _alvos, DamageType.TRUTH);
		}
	}
}

function addItem(_itemID) {
	checkInvFirstEmptySpace();
	
	if (global.invFirstEmptySpace == -1) {
		show_debug_message("inventário cheio viadinho");
		return;
	}
	
	global.inventario[global.invFirstEmptySpace] = _itemID;
	show_debug_message("pegou :)");
}

function checkInvFirstEmptySpace() {
	for (var i = 0; i < array_length(global.inventario); i++) {
		if (global.inventario[i] == undefined) {
			global.invFirstEmptySpace = i;
			return;
		}
	}
	
	global.invFirstEmptySpace = -1;
	return;
}