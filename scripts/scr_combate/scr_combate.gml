function Dano(_value, _alvo, _typeD) {
	if(_typeD == TypeDamage.PHYSICAL) {
		_value = max(0, _value - _alvo.defs.defesa);
		_alvo.defs.vida -= _value;
	} else if (_typeD == TypeDamage.MAGIC) {
		_value = max(0, _value - _alvo.defs.defesamagica);
		_alvo.defs.vida -= _value;
	} else {
		_alvo.defs.vida -= _value;
	}
	
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

function setInimigos(_arrayInimigos, _info) {
	var origX = 260;
	var origY = 85;
		
	for (var i = 0; i < array_length(_info); i++) {
		var ii = _info[i];
		var inst = instance_create_layer(origX + ii.pos[0], origY + ii.pos[1], "Instances", ii.obj);
		array_insert(_arrayInimigos, i, inst);
	}
}	

function setAliados(_arrayAliados) {
	var _inst = instance_create_layer(50, 50, "Instances", obj_cavaleiro);
	var _inst2 = instance_create_layer(50, 120, "Instances", obj_mago);
	array_push(_arrayAliados, _inst, _inst2);
}

function checkStatus(_arrayAliados, _arrayInimigos) {
	var _status = 0;
	
	for (var i = 0; i < array_length(_arrayAliados); i ++) {
		if (_arrayAliados[i].defs.isDown()) continue;
		
		_status = _arrayAliados[i].defs.status;
		if (_status.veneno == true) {
			Dano(2, _arrayAliados[i], TypeDamage.TRUE);
		} 
		
		if (_status.queimadura == true) {
			Dano(1, _arrayAliados[i], TypeDamage.TRUE);
		}
	}
	
	for (var i = 0; i < array_length(_arrayInimigos); i ++) {
		if (_arrayInimigos[i].defs.isDown() == true) continue;
		
		_status = _arrayInimigos[i].defs.status;
		if (_status.veneno == true) {
			Dano(2, _arrayInimigos[i], TypeDamage.TRUE);
		} 
		
		if (_status.queimadura == true) {
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
