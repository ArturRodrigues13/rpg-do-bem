switch (item) {
			
	case "pocaodeVida":
		
		sprite_index = spr_pocaoVida;
		break;
	
	
	case "pedra":
		
		sprite_index = spr_pedra;
		break;
	
	
	default:
		
		break;
}

if(keyboard_check_pressed(vk_space)) {
	
	if(place_meeting(x,y, obj_player)) {
	
		addItem(global.itens[$ item]);
	}
}

