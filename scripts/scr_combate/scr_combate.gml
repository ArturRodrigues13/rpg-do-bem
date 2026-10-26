function Dano(_value, _alvo, _typeD) {
	if (_typeD == TypeDamage.PHYSICAL) {
		_value = max(0, _value - _alvo.defs.defesa);
	} else if (_typeD == TypeDamage.MAGIC) {
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

function Ataque(_player, _alvo, _typeD) {
	var _atAli = _player.defs;
	var _mult = (random(1) <= _atAli.chanceCrit) ? _atAli.danoCrit : 1;
	var _dano = (_typeD == TypeDamage.PHYSICAL) ? _atAli.ataque * _mult : _atAli.ataquemagico * _mult;
	Dano(_dano, _alvo, _typeD);
}

global.allyData = {
	knight0: {
		obj: obj_cavaleiro,
	},
	mage0: {
		obj: obj_mago,
	},
};

function Battle(_args) constructor {
	args = _args;

	// TODO: (talvez) parar de usar várias variáveis globais (e.g. `global.partyInimiga`) aqui e centralizar tudo em `global.battle`.
	// TODO: dá pra refatorar initEnemies e initAllies, eles tem código comum (e acho que seria bom por aqui já definir as dimensões do array)

	// @desc Instancia os aliados na batalha e os coloca em um array.
	initAllies = function() {
		var _ret = [];
		var _arr = args.allyNames;
		var _x = 50;
		var _y = 50;

		for (var _i = 0; _i < array_length(_arr); _i++) {
			var _a = global.allyData[$ _arr[_i]];
			var _inst = instance_create_layer(_x, _y, "Instances", _a.obj);
			_y += 70;
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

		for (var _i = 0; _i < array_length(_ei); _i++) {
			var _obj = _ei[_i].obj;
			var _row = _i div 2;
			var _col = _i mod 2;
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
			Dano(2, _arrayAliados[i], TypeDamage.TRUE);
		}
		
		if (_status.queimadura) {
			Dano(1, _arrayAliados[i], TypeDamage.TRUE);
		}
	}
	
	for (var i = 0; i < array_length(_arrayInimigos); i ++) {
		if (_arrayInimigos[i].defs.isDown()) continue;
		
		_status = _arrayInimigos[i].defs.status;
		if (_status.veneno) {
			Dano(2, _arrayInimigos[i], TypeDamage.TRUE);
		}
		
		if (_status.queimadura) {
			Dano(1, _arrayInimigos[i], TypeDamage.TRUE);
		}
	}
}

function checkDeath(_inst) {
	if (_inst.defs.vida <= 0) {
		_inst.sprite_index = _inst.deathSprite;
		_inst.image_index = 0;
	}
}
