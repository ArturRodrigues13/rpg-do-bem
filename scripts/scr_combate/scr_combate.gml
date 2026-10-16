function Ataque(_player, _Arrayinimigos, _alvo) {
	var e = _Arrayinimigos[_alvo];
	
	var at_ali = _player.defs;
	var dano;
	var mult = random(1) <= at_ali.chanceCrit ? at_ali.danoCrit : 1;
	
	dano = at_ali.ataque * mult - e.defs.defesa;

	dano = max(0, dano);
	
	e.defs.vida -= dano;
	
	if (e.defs.vida <= 0) {
		instance_destroy(e);
		array_delete(_Arrayinimigos, _alvo, 1);
	}
}

function setInimigos(_arrayInimigos, _info) {
	var origX = 400;
	var origY = 200;
		
	for (var i = 0; i < array_length(_info); i++) {
		var ii = _info[i];
		var inst = instance_create_layer(origX + ii.pos[0], origY + ii.pos[1], "Instances", ii.obj);
		array_insert(_arrayInimigos, i, inst);
	}
}	

function setAliados(_arrayAliados) {
	
	var inst = instance_create_layer(50, 200, "Instances", obj_cavaleiro);
	
	array_insert(_arrayAliados, 0, inst);
}	

