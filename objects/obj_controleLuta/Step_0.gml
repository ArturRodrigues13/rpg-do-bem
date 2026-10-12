if(atacantes == turno.ALIADOS) {
	
	var quantInimigos = array_length(global.partyInimiga);
	var aliado_atacante = global.partyAliada[indice];
	
	if(keyboard_check_pressed(ord("A")) && alvo > 0) alvo--;
	
	if(keyboard_check_pressed(ord("D")) && alvo < quantInimigos - 1) alvo++;
	   
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
	 
} else if(atacantes == turno.INIMIGOS) {
	
	if(keyboard_check_pressed(vk_space)) {
		atacantes = turno.ALIADOS; 
	}
}

if(array_length(global.partyInimiga) == 0) game_end();