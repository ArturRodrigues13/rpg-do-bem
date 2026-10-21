function Dano(_value, _alvo, _array, _index) {
	_alvo.defs.vida -= _value;
	
	if (_alvo.defs.vida <= 0) {
		_alvo.defs.morto = true;
		_alvo.sprite_index = _alvo.deathSprite;
		_alvo.image_index = 0;
	}
}

function Ataque(_player, _Arrayinimigos, _alvo) {
	var e = _Arrayinimigos[_alvo];
	
	var at_ali = _player.defs;
	var dano;
	var mult = random(1) <= at_ali.chanceCrit ? at_ali.danoCrit : 1;
	
	dano = at_ali.ataque * mult - e.defs.defesa;
	dano = max(0, dano);
	Dano(dano, e, _Arrayinimigos, _alvo);
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
	var inst = instance_create_layer(50, 50, "Instances", obj_cavaleiro);
	array_insert(_arrayAliados, 0, inst);
}

function checkStatus(_arrayAliados, _arrayInimigos) {
	var _status = 0;
	
	for (var i = 0; i < array_length(_arrayAliados); i ++) {
		if (_arrayAliados[i].defs.morto == true) continue;
		
		_status = _arrayAliados[i].defs.status;
		if (_status.veneno == true) {
			Dano(2, _arrayAliados[i], _arrayAliados, i);
		} 
		
		if (_status.queimadura == true) {
			Dano(1, _arrayAliados[i], _arrayAliados, i);
		}
	}
	
	for (var i = 0; i < array_length(_arrayInimigos); i ++) {
		if (_arrayInimigos[i].defs.morto == true) continue;
		
		_status = _arrayInimigos[i].defs.status;
		if (_status.veneno == true) {
			Dano(2, _arrayInimigos[i], _arrayInimigos, i);
		} 
		
		if (_status.queimadura == true) {
			Dano(1, _arrayInimigos[i], _arrayInimigos, i);
		}
	}
}
