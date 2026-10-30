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

function Ataque(_attacker, _target, _typeD) {
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

function Battle(_args) constructor {
	args = _args;
	//turnoAtual = Turno.ALIADOS;
	allyIdx = 0;
	
	timeStep = 0.1;
	actionCounter = 0.0;
	
	actionQueue = new Queue();

	// TODO: (talvez) parar de usar várias variáveis globais (e.g. `global.partyInimiga`) aqui e centralizar tudo em `global.battle`.
	// TODO: dá pra refatorar initEnemies e initAllies, eles tem código comum (e acho que seria bom por aqui já definir as dimensões do array)
	
	drawStepBattleProgressBar = function () {
		
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
			drawCharacterStepBar(ally.defs,ally.x,ally.y);
		}
		
		// BARRA DOS INIMIGOS
		
		for (var i = 0; i < array_length(enemies); i++) {
			
			var enemy = enemies[i];
			drawCharacterStepBar(enemy.defs,enemy.x,enemy.y);
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
			
			if(ed.isDown()) continue;
			var thr = ed.getActionThreshold();
			
			ed.actionCounter += timeStep;
			if (ed.actionCounter >= thr) {
				ed.actionCounter -= thr;
				actionQueue.put(["enemy", i]);
			}
		}
		
		for (var i = 0; i < array_length(allies); i++) {
			var ad = allies[i].defs;
			var thr = ad.getActionThreshold();
			
			ad.actionCounter += timeStep;
			if (ad.actionCounter >= thr) {
				ad.actionCounter -= thr;
				actionQueue.put(["ally", i]);
			}
		}
	}

	// @desc Instancia os aliados na batalha e os coloca em um array.
	initAllies = function() {
		var _ret = [];
		var _arr = args.allyNames;
		var _x = 40;
		var _y = 50;

		for (var i = 0; i < array_length(_arr); i++) {
			var _a = global.allyData[$ _arr[i]];
			var _inst = instance_create_layer(_x, _y, "Instances", _a.obj);
			_y += 70;
			
			if(i == 1) {
				
				_x += 80;
				_y = 50;
			} 
			
			array_push(_ret, _inst);
		}

		return _ret;
	}
	allies = initAllies();
	global.partyAliada = allies;

	initEnemies = function() {
		var _ret = [];
		var _ei = global.enemiesInfo; // FIXME: omds não acessar isso direto
		var _x = 200;
		var _y = 25;

		for (var i = 0; i < array_length(_ei); i++) {
			var _obj = _ei[i].obj;
			var _row = i div 2;
			var _col = i mod 2;
			var _inst = instance_create_layer(_x + _col * 120, _y + _row * 60, "Instances", _obj);
			array_push(_ret, _inst);
		}

		return _ret;
	}
	enemies = initEnemies();
	global.partyInimiga = enemies;
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
		_inst.sprite_index = _inst.deathSprite;
		_inst.image_index = 0;
	}
}

function dumbAttack(_allys, _enemy) {
	
	var choice = irandom(array_length(_allys) - 1)
	
	Ataque(_enemy, _allys[choice], _enemy.defs.tipoAtaque);
}
