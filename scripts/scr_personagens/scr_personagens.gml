function Defs(_args) constructor {
	vida = _args.vida;
	ataque = _args.ataque;
	ataquemagico = _args.ataquemagico;
	defesa = _args.defesa;
	defesamagica = _args.defesamagica;
	chanceCrit = _args.chanceCrit;
	danoCrit = _args.danoCrit;
	speed = _args.speed;
	acessorios = _args.acessorios;
	
	actionCounter = 0;
	
	status = {
		veneno: false,
		queimadura: false,
		congelado: false,
		forte: false
	};
	
	isDown = function() {
		return vida <= 0;
	}
	
	getActionThreshold = function() {
		var ret = 1 / speed;
		ret = round(ret * 10) / 10; // arredondando p/ uma casa decimal
		return ret;
	}
}
