if (instance_exists(obj_player)) {
	x = lerp(x, obj_player.x - (camW / 2), 0.1);
	y = lerp(y, obj_player.y - (camH / 2), 0.1);

	x = clamp(x, 0, room_width - camW);
	y = clamp(y, 0, room_height - camH);
	
	camera_set_view_pos(cam, x, y);
}