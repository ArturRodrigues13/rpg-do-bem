defs = { 
	vida: 10,
	ataque: 1,
	ataquemagico: 1,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: .3,
	danoCrit: 2.5,
	velocidade: 1,
	tipoAtaque: TypeDamage.PHYSICAL,
	
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