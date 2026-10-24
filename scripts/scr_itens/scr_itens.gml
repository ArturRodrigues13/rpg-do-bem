global.itensData = {
	pocaodeVida: {
		ID: 1,
		nome: "Vida",
		descricao: "cura (o inimigo, whatever lil bloba)",
		spr: spr_pocaoVida,
		alvo: TargetScope.AllySingle,
		uso: function(_alvo) {
			_alvo.defs.vida += 20;
		}
	},
	
	pedra: {
		ID: 2,
		nome: "Pedra",
		descricao: "taca pedra NO INIMIGO E EXECUTA\nELE DE FORMA BRUTAL",
		spr: spr_pedra,
		alvo: TargetScope.EnemySingle,
		uso: function(_alvo) {
			Dano(10, _alvo, TypeDamage.PHYSICAL);
		}
	},
	
	boladeFogo: {
		ID: 3,
		nome: "Fogo",
		descricao: "Nuke",
		spr: spr_bolaFogo,
		alvo: TargetScope.EnemyAll,
		uso: function(_alvos) {
			DanoAll(999, _alvos, TypeDamage.TRUE);
		}
	}
}

function searchItem(_ID) {
	var keys = variable_struct_get_names(global.itensData);
	
	for (var i = 0; i < array_length(keys); i++) {
		var item = variable_struct_get(global.itensData, keys[i]);
		if (item.ID == _ID) return item;
	}
	
	return noone;
}

function addItem(_itemID) {
	checkLastEmptySpace();
	
	if (global.lastEmptySpace == -1) {
		show_debug_message("inventário cheio viadinho");
		return;
	}
	
	global.inventario[global.lastEmptySpace] = global.itensData[$ _itemID];
	show_debug_message("pegou :)");
}

function checkLastEmptySpace() {
	for (var i = 0; i < array_length(global.inventario); i++) {
		if (global.inventario[i] == noone) {
			global.lastEmptySpace = i;
			return;
		}
	}
	
	global.lastEmptySpace = -1;
	return;
}