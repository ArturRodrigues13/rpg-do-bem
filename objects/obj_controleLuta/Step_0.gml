if(atacantes == turno.ALIADOS) {
	
	if(estado_atual == escolha.ESCOLHENDO) {
		
		if(keyboard_check_pressed(vk_down) && indice_escolha == 0) indice_escolha++;
	
		if(keyboard_check_pressed(vk_up) && indice_escolha == 1) indice_escolha--;
		
		if(keyboard_check_pressed(vk_enter)) {
			
			if(indice_escolha == 0) estado_atual = escolha.ATACAR else estado_atual = escolha.ITEM;
		}
	
	} else if(estado_atual == escolha.ATACAR) {
		
		if(keyboard_check_pressed(vk_escape)) {
			
			estado_atual = escolha.ESCOLHENDO;
		}
		
		var quantInimigos = array_length(global.partyInimiga);
		var aliado_atacante = global.partyAliada[indice_aliados];
	
		if(keyboard_check_pressed(ord("A")) && alvo > 0) alvo--;
	
		if(keyboard_check_pressed(ord("D")) && alvo < quantInimigos - 1) alvo++;
	   
		if(keyboard_check_pressed(vk_enter)) {
		
			Ataque(aliado_atacante, global.partyInimiga, alvo);
			quantInimigos = array_length(global.partyInimiga);
			indice_aliados++;
		}
	
		if(indice_aliados == array_length(global.partyAliada)) {
		
			indice_aliados = 0;
			alvo = 0;
			atacantes = turno.INIMIGOS;
		}
	
		alvo = min(alvo, quantInimigos);
		
	} else if (estado_atual == escolha.ITEM) {
		
		if(keyboard_check_pressed(vk_escape)) {
			
			estado_atual = escolha.ESCOLHENDO;
		}
	}
	
} else if(atacantes == turno.INIMIGOS) {
	
	if(keyboard_check_pressed(vk_enter)) {
		
		estado_atual = escolha.ESCOLHENDO;
		indice_escolha = 0;
		atacantes = turno.ALIADOS; 
	}
}

if(array_length(global.partyInimiga) == 0) game_end();