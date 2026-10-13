if(atacantes == turno.ALIADOS) {
	var quantInimigos = array_length(global.partyInimiga);
	var aliado_atacante = global.partyAliada[indice];
	
	var dir_novo_alvo = [
		keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left),
		keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up),
	];
	if (dir_novo_alvo[0] != 0 || dir_novo_alvo[1] != 0) {		
		BuscarAlvo(dir_novo_alvo);
	}
	   
	if(keyboard_check_pressed(vk_space)) {
		Ataque(aliado_atacante, global.partyInimiga, alvo);
		quantInimigos = array_length(global.partyInimiga);
		indice++;
	}
	
	if(indice == array_length(global.partyAliada)) {
		
		indice = 0;
		alvo = 0;
		atacantes = turno.INIMIGOS;
	}
	
	alvo = min(alvo, quantInimigos);
	
	var inimigos = global.partyInimiga;
	setinhaTargetX = inimigos[alvo].x - 20;
	setinhaTargetY = inimigos[alvo].y;
	 
} else if(atacantes == turno.INIMIGOS) {
	
	if(keyboard_check_pressed(vk_space)) {
		atacantes = turno.ALIADOS; 
	}
}

setinhaY = lerp(setinhaY, setinhaTargetY, 0.475);
setinhaX = lerp(setinhaX, setinhaTargetX, 0.475);

if(array_length(global.partyInimiga) == 0) game_end();