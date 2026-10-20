global.itens = {
	
	pocaodeVida: {
		
		nome: "Vida",
		descricao: "cura (o inimigo, whatever lil bloba)",
		spr: spr_pocaoVida,
		alvo: tipoAlvo.INIMIGOUNICO,
		uso: function(_alvo) {
			_alvo.defs.vida += 20
		}
	},
	
	pedra: {
		nome: "Pedra",
		descricao: "taca pedra NO INIMIGO E EXECUTA\n ELE DE FORMA BRUTAL",
		spr: spr_pedra,
		alvo: tipoAlvo.INIMIGOUNICO,
		uso: function(_alvo) {
			Dano(10, _alvo, global.partyInimiga, 0);
		}
	}
}

function addItem(_item, _index) {
	
	array_insert(global.inventario, _index,_item);
	array_delete(global.inventario, _index + 1,1);
}

addItem(global.itens.pedra,0);
addItem(global.itens.pedra,1);
addItem(global.itens.pocaodeVida,2);
addItem(global.itens.pedra,3);