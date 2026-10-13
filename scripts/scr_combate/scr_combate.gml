function Ataque(_player, _Arrayinimigos, _alvo) {
	
	var at_ali = _player.atributos;
	var dano;
	var mult = random(1) <= at_ali.chanceCrit ? at_ali.danoCrit : 1;
	
	dano = at_ali.ataque * mult - _Arrayinimigos[_alvo].atributos.defesa;

	dano = max(0, dano);
	
	_Arrayinimigos[_alvo].atributos.vida -= dano;
	
	if(_Arrayinimigos[_alvo].atributos.vida <= 0) {
		
		instance_destroy(_Arrayinimigos[_alvo]);
		array_delete(_Arrayinimigos,_alvo,1);
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