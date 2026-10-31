function Dano(_value, _alvo, _typeD) {
	if (_typeD == DamageType.PHYSICAL) {
		_value = max(0, _value - _alvo.defs.defesa);
	} else if (_typeD == DamageType.MAGIC) {
		_value = max(0, _value - _alvo.defs.defesamagica);
	}
	_alvo.defs.vida -= _value;

	checkDeath(_alvo);
}

function DanoAll(_value, _alvos, _typeD) {
	for (var i = 0; i < array_length(_alvos); i++) {
		if (!_alvos[i].defs.isDown()) Dano(_value, _alvos[i], _typeD);
	}
}

function Ataque(_attacker, _target, _typeD, _element) {
	var atDefs = _attacker.defs;
	var mult = (random(1) <= atDefs.chanceCrit) ? atDefs.danoCrit : 1;
	var dano = 0;

	if(_typeD == DamageType.PHYSICAL) {
		dano = atDefs.ataque * mult;
	} else if (_typeD == DamageType.MAGIC) {
		dano = atDefs.ataquemagico * mult;
	} else {
		dano = (atDefs.ataque + atDefs.ataquemagico) * mult;
	}

	Dano(dano, _target, _typeD);
}

global.allyData = {
	knight0: {
		obj: obj_cavaleiro,
	},
	mage0: {
		obj: obj_mago,
	},

	sup: {
		obj: obj_sup,
	},
};

/// @desc Inicializa uma batalha, preparando os objetos e indo para a cena de batalha.
function initBattle() {
	// TODO
}

function Battle(_args) constructor {
	args = _args;
	allyIdx = 0;

	timeStep = 0.1;
	actionCounter = 0.0;

	actionQueue = new Queue();

	// TODO: dá pra refatorar initEnemies e initAllies, eles tem código comum (e acho que seria bom por aqui já definir as dimensões do array)

	drawStepBattleProgressBar = function() {
		// BARRA DO PROGRESSO GERAL:

		var bar_width = 100;
		var bar_height = 15;
		var bar_x = 10;
		var bar_y = 10;

		var progress = actionCounter / 1;
		var current_bar_width = bar_width * progress;

		draw_set_color(c_gray);
		draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

		draw_set_color(c_red);
		draw_rectangle(bar_x, bar_y, bar_x + current_bar_width, bar_y + bar_height, false);

		// BARRA DOS ALIADOS
		for (var i = 0; i < array_length(allies); i++) {
			var ally = allies[i];
			if (ally.defs.isDown()) continue;
			drawCharacterStepBar(ally.defs, ally.x, ally.y);
		}

		// BARRA DOS INIMIGOS
		for (var i = 0; i < array_length(enemies); i++) {
			var enemy = enemies[i];
			if (enemy.defs.isDown()) continue;
			drawCharacterStepBar(enemy.defs, enemy.x, enemy.y);
		}
	}

	stepBattleTime = function() {
		if (!actionQueue.isEmpty()) {
			// tem coisas acontecendo, não avançar o tempo
			return;
		}

		actionCounter += timeStep;
		if (actionCounter >= 1) {
			actionQueue.put(["moment"]);
			actionCounter -= 1;
		}

		for (var i = 0; i < array_length(enemies); i++) {
			var ed = enemies[i].defs;

			if (ed.isDown()) continue;
			var thr = ed.getActionThreshold();

			ed.actionCounter += timeStep;
			if (ed.actionCounter >= thr) {
				ed.actionCounter -= thr;
				actionQueue.put(["enemy", i]);
			}
		}

		for (var i = 0; i < array_length(allies); i++) {
			var ad = allies[i].defs;

			if (ad.isDown()) continue;
			var thr = ad.getActionThreshold();

			ad.actionCounter += timeStep;
			if (ad.actionCounter >= thr) {
				ad.actionCounter -= thr;
				actionQueue.put(["ally", i]);
			}
		}
	}

	/// @desc Instancia objetos em uma grade (ordem row-first) com as dimensões especificadas.
	/// @param {Array} _objs Objetos a serem instanciados na batalha.
	/// @param {Array} _origin Vetor de posição do primeiro objeto (topo-esquerda).
	/// @param {Array} _offset Vetor de offset para cada objeto adicionado.
	/// @param {Real} _ncols Número de colunas na grade.
	/// @returns A lista de objetos devidamente instanciados.
	instObjGrid = function(_objs, _origin, _offsets, _ncols) {
		// TODO: aceitar layouts mais complexos (não necessariamente uma matriz seca)

		var ret = [];
		var ox = _origin[0];
		var oy = _origin[1];
		for (var i = 0; i < array_length(_objs); i++) {
			// decompondo índice em linha-coluna
			var row = i div _ncols;
			var col = i mod _ncols;

			var inst = instance_create_layer(ox + col * _offsets[0], oy + row * _offsets[1], "Instances", _objs[i]);
			array_push(ret, inst);
		}
		return ret;
	}

	// inicializando arrays & grids de aliados e inimigos
	allies = instObjGrid(
		array_map(args.allyNames, function(_x) { return global.allyData[$ _x].obj; }),
		[40, 50], [80, 50], 2);
	enemies = instObjGrid(
		array_map(global.enemiesInfo, function(_x) { return _x.obj; }),
		[200, 25], [120, 60], 2);

	/// @desc Faz um inimigo específico realizar uma ação aleatória em seu banco de ações.
	enemyRandomAction = function(_enemy) {
		if (array_length(allies) == 0) return;

		var actions = _enemy.defs.actions;
		if (array_length(actions) == 0) return;

		var targetIdx = irandom(array_length(allies) - 1);
		var actionIdx = irandom(array_length(actions) - 1);
		actions[actionIdx].onUse(allies[targetIdx], _enemy);
	}
}

function checkStatus(_arrayAliados, _arrayInimigos) {
	var _status = 0;

	for (var i = 0; i < array_length(_arrayAliados); i ++) {
		if (_arrayAliados[i].defs.isDown()) continue;

		_status = _arrayAliados[i].defs.status;
		if (_status.veneno) {
			Dano(2, _arrayAliados[i], DamageType.TRUTH);
		}

		if (_status.queimadura) {
			Dano(1, _arrayAliados[i], DamageType.TRUTH);
		}
	}

	for (var i = 0; i < array_length(_arrayInimigos); i ++) {
		if (_arrayInimigos[i].defs.isDown()) continue;

		_status = _arrayInimigos[i].defs.status;
		if (_status.veneno) {
			Dano(2, _arrayInimigos[i], DamageType.TRUTH);
		}

		if (_status.queimadura) {
			Dano(1, _arrayInimigos[i], DamageType.TRUTH);
		}
	}
}

function checkDeath(_inst) {
	if (_inst.defs.vida <= 0) {
		_inst.sprite_index = _inst.defs.deathSprite;
		_inst.image_index = 0;
	}
}
