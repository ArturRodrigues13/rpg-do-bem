var _gk = global.keys;

var _dir = [
	_gk.right.isHeld() - _gk.left.isHeld(),
	_gk.down.isHeld() - _gk.up.isHeld(),
];
_dir = VecNormScale(_dir, vel);

x += _dir[0];
y += _dir[1];

if (_gk.confirm.isPressed() && place_meeting(x, y, obj_inimigo)) {
	var inimigo = instance_nearest(x, y, obj_inimigo);
	global.enemiesInfo = inimigo.infoLuta;
	room_goto(rm_testeLuta);
}

// TESTE TESTE TIRAR DEPOIS

if (keyboard_check_pressed(vk_f4)) {
	save(1);
}

if (keyboard_check_pressed(vk_f5)) {
	load(1);
}

// SEI LA CARA, TESTE!!!