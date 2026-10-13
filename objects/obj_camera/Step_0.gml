if (instance_exists(obj_player)) {
	
	x = lerp(x,obj_player.x - (camera_largura / 2 ),0.1);
	y = lerp(y,obj_player.y - (camera_altura / 2 ),0.1);

	x = clamp(x,0,room_width - camera_largura);
	y = clamp(y,0,room_height - camera_altura);
	
	camera_set_view_pos(view_camera[0],x,y);
}