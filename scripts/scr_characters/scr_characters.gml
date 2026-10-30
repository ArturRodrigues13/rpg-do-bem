function Defs(_args) constructor {
	nome = _args.nome;
	vida = _args.vida;
	ataque = _args.ataque;
	ataquemagico = _args.ataquemagico;
	defesa = _args.defesa;
	defesamagica = _args.defesamagica;
	chanceCrit = _args.chanceCrit;
	danoCrit = _args.danoCrit;
	tipoAtaque = _args.tipoAtaque;
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

function drawCharacterStepBar(_defs, _x, _y) {
	
	var bar_width = 32;
	var bar_height = 5;
	var bar_x = _x - 16;
	var bar_y = _y + 20;
	
	var progress = _defs.actionCounter / _defs.getActionThreshold();
	var current_bar_width = bar_width * progress;
	
	draw_set_color(c_gray);
	draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);
	
	draw_set_color(c_blue);
	draw_rectangle(bar_x, bar_y, bar_x + current_bar_width, bar_y + bar_height, false);
	
	draw_set_color(c_white);
}
