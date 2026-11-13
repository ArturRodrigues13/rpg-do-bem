function Defs(_args) constructor {
	name = _args.name;
	elements = _args.elements;
	vida = _args.vida;
	energy = _args.energy;
	maxEnergy = _args.maxEnergy;
	ataque = _args.ataque;
	ataquemagico = _args.ataquemagico;
	defesa = _args.defesa;
	defesamagica = _args.defesamagica;
	chanceCrit = _args.chanceCrit;
	danoCrit = _args.danoCrit;
	actions = _args.actions;
	speed = _args.speed;
	actions = _args.actions;
	acessorios = _args.acessorios;
	deathSprite = _args.deathSprite;
	actionCounter = 0;

	status = array_create(Status._MAX);

	for (var i = 0; i < Status._MAX; i++) {
		status[i] = {stacks: 0, started: false};
	}
	
	skipAction = false;

	isDown = function() {
		return vida <= 0;
	}

	/// @desc Calcula o quanto do contador de ação é necessário para poder fazer uma ação.
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

// @desc Desenhar ícones de Status e quantidade de stacks pra cada personagem em batalha
function drawStatusIcons(_battleInstances) {
	for (var i = 0; i < array_length(_battleInstances); i++) {
		var inst = _battleInstances[i];
		
		if (inst.defs.isDown()) continue;
		
		var originIconsX = inst.x - 16;
		var originIconsY = inst.y - 20;
		var offsetX = 0;
		for(var j = 0; j < Status._MAX; j++) {
			if(inst.defs.status[j].stacks > 0) {
				var info = getStatusIconInfo(j);
				draw_sprite(info[0], 0, originIconsX + offsetX, originIconsY);
				
				draw_set_colour(info[1]);
				draw_text(originIconsX + offsetX, originIconsY - 10, inst.defs.status[j].stacks);
				draw_set_colour(c_white);
				
				offsetX += 8;
			}
		}
	}
}