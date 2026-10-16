enum tipoAlvo {
	
	ALIADOUNICO,
	ALIADOS,
	INIMIGOUNICO,
	INIMIGOS
}

global.itens = {
	
	pocaodeVida: {
		
		nome: "vida",
		descricao: "cura",
		spr: spr_inimigo,
		alvo: tipoAlvo.ALIADOUNICO,
		uso: function(_alvo) {
			_alvo.defs.vida += 20
		}
	},
	
	pedra: {
		nome: "pedra",
		descricao: "taca pedra",
		spr: spr_player,
		alvo: tipoAlvo.INIMIGOUNICO,
		uso: function(_alvo) {
			Dano(10, _alvo, global.partyInimiga, 0);
		}
	}
}

function addItem(_item) {
	
	array_push(global.inventario,_item);
}

addItem(global.itens.pedra);
addItem(global.itens.pedra);
addItem(global.itens.pocaodeVida);
addItem(global.itens.pedra);