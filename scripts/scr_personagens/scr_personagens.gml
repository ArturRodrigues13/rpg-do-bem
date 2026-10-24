function Definedefs(_vida, _ataque, _defesa, _chanceCrit, _danoCrit, _acessorios) constructor {
	vida = _vida;
	ataque = _ataque;
	defesa = _defesa;
	chanceCrit = _chanceCrit;
	danoCrit = _danoCrit;
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