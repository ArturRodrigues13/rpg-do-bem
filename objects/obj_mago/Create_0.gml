defs = { 
	vida: 5,
	ataque: 1,
	ataquemagico: 10,
	defesa: 0,
	defesamagica: 5,
	chanceCrit: .1,
	danoCrit: 2,
	velocidade: 2,
	tipoAtaque: DamageType.MAGIC,
	
	status: {
		veneno: false,
		queimadura: false,
		congelado: false,
		forte: false
	},
	
	acessorios: [],
	equipamento: {
		
		arma: undefined,
		amuleto: undefined,
		vestimenta: undefined,
	},
	
	isDown: function() {
		return vida <= 0;
	}
};