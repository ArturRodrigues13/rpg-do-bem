function Dano(_value, _alvo, _typeD) {
	
	if(_typeD == TypeDamage.PHYSICAL) {
		
		var defense = max(0, _alvo.defs.defesa);
	
		_value = max (0, _value - defense);
		
		_alvo.defs.vida -= _value;
		
	} else if (_typeD == TypeDamage.MAGIC) {
		
		var defense = max(0, _alvo.defs.defesamagica);
	
		_value = max (0, _value - defense);
		
		_alvo.defs.vida -= _value;
		
	} else {
		
		_alvo.defs.vida -= _value;
	}
	
	checkDeath(_alvo);
}

function DanoAll(_value, _alvos, _typeD) {
	
	for (var i = 0; i < array_length(_alvos); i++) {
		
		if(_alvos[i].defs.isDown() == false) Dano(_value, _alvos[i], _typeD);
	}
}

function Ataque(_player, _Arrayinimigos, _alvo) {
	var e = _Arrayinimigos[_alvo];
	
	var at_ali = _player.defs;
	var dano;
	var mult = random(1) <= at_ali.chanceCrit ? at_ali.danoCrit : 1;
	
	dano = at_ali.ataque * mult - e.defs.defesa;
	dano = max(0, dano);
	Dano(dano, e, TypeDamage.PHYSICAL);
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
