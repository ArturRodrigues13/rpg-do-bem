function Definedefs(_vida, _ataque, _ataquemagico, _defesa, _defesamagica, _velocidade, _tipoAtaque, _chanceCrit, _danoCrit, _acessorios) constructor {
	vida = _vida;
	ataque = _ataque;
	ataquemagico = _ataquemagico;
	defesa = _defesa;
	defesamagica = _defesamagica;
	chanceCrit = _chanceCrit;
	danoCrit = _danoCrit;
	velocidade = _velocidade;
	acessorios = _acessorios;
	
	status = {
		veneno: false,
		queimadura: false,
		congelado: false,
		forte: false
	};
	
	isDown = function() {
		return vida <= 0;
	}
}