defs = { 
	vida: 5,
	ataque: 1,
	ataquemagico: 10,
	defesa: 0,
	defesamagica: 5,
	chanceCrit: .1,
	danoCrit: 2,
	velocidade: 2,
	tipoAtaque: TypeDamage.MAGIC,
	
	status: {
		veneno: false,
		queimadura: false,
		congelado: false,
		forte: false
	},
	
	acessorios: [],
	equipamento: {
		
		arma: noone,
		amuleto: noone,
		vestimenta: noone,
	},
	
	isDown: function() {
		return vida <= 0;
	}
};