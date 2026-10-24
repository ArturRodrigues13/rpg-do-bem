switch (item) {
			
	case "pocaodeVida":
		
		sprite_index = spr_pocaoVida;
		break;
	
	
	case "pedra":
		
		sprite_index = spr_pedra;
		break;
	
	case "boladeFogo":
		
		sprite_index = spr_bolaFogo;
		break;
	
	default:
		
		break;
}

if(keyboard_check_pressed(vk_space)) {
	
	if(place_meeting(x,y, obj_player)) {
	
		addItem(item);
	}
}

