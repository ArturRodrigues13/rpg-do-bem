global.itens = {
	pocaodeVida: {
		nome: "Vida",
		descricao: "cura (o inimigo, whatever lil bloba)",
		spr: spr_pocaoVida,
		alvo: TargetScope.EnemySingle,
		uso: function(_alvo) {
			_alvo.defs.vida += 20
		}
	},
	
	pedra: {
		nome: "Pedra",
		descricao: "taca pedra NO INIMIGO E EXECUTA\nELE DE FORMA BRUTAL",
		spr: spr_pedra,
		alvo: TargetScope.EnemySingle,
		uso: function(_alvo) {
			Dano(10, _alvo, global.partyInimiga, 0);
		}
	}
}

function addItem(_item) {
	
	checkLastEmptySpace();
	
	if(global.lastEmptySpace == -1) {
		show_debug_message("inventário cheio viadinho");
		return;
	}
	
	global.inventario[global.lastEmptySpace] = _item;
	show_debug_message("pegou :)");
}

function checkLastEmptySpace() {

	for(var i = 0; i < array_length(global.inventario); i++) {
		
		if(global.inventario[i] == noone) {
			global.lastEmptySpace = i;
			return;
		}
	}
	
	global.lastEmptySpace = -1;
	return;
}
