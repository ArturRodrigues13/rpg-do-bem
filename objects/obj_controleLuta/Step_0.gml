if(atacantes == turno.ALIADOS) {
	
	if(estado_atual == estado.ESCOLHENDO) {
		
		if(keyboard_check_pressed(vk_down) && indice_escolha < 2) indice_escolha++;
	
		if(keyboard_check_pressed(vk_up) && indice_escolha > 0) indice_escolha--;
		
		if(keyboard_check_pressed(vk_enter)) {
			
			if(indice_escolha == 0) {
				
				estado_atual = estado.ATACAR
			} else if(indice_escolha == 1) {
				
				estado_atual = estado.ITEM;
			} else {
				
				game_end();
			}
		}
	
	} else if(estado_atual == estado.ATACAR) {

		var inimigos = global.partyInimiga;
		
		if (alvo >= 0 && alvo < array_length(inimigos)) {
			setinhaTargetX = inimigos[alvo].x - 20;
			setinhaTargetY = inimigos[alvo].y;
		}
		
		if(keyboard_check_pressed(vk_escape)) {
			estado_atual = estado.ESCOLHENDO;
		}
		
		var quantInimigos = array_length(global.partyInimiga);
		var aliado_atacante = global.partyAliada[indice_aliados];
		
		var dir_novo_alvo = [
			keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left),
			keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up),
		];
		if (VecNotEmpty(dir_novo_alvo)) BuscarAlvo(dir_novo_alvo);
		
		if (keyboard_check_pressed(vk_enter)) {
			Ataque(aliado_atacante, global.partyInimiga, alvo);
			quantInimigos = array_length(global.partyInimiga);
			indice_aliados++;
		}
	
		if(indice_aliados == array_length(global.partyAliada)) {
			indice_aliados = 0;
			alvo = 0;
			atacantes = turno.INIMIGOS;
		}
	
		alvo = clamp(alvo, 0, quantInimigos);
		
	} else if (estado_atual == estado.ITEM) {
		
		if(keyboard_check_pressed(vk_escape)) {
			
			estado_atual = estado.ESCOLHENDO;
		}
	}
	
} else if(atacantes == turno.INIMIGOS) {
	
	if(keyboard_check_pressed(vk_enter)) {
		
		estado_atual = estado.ESCOLHENDO;
		indice_estado = 0;
		atacantes = turno.ALIADOS; 
	}
}

setinhaY = lerp(setinhaY, setinhaTargetY, 0.475);
setinhaX = lerp(setinhaX, setinhaTargetX, 0.475);

if(array_length(global.partyInimiga) == 0) game_end();
