// Só pra deixar ele parado
if(!obj_controlInventory.mstack.isEmpty()) exit;

var _gk = global.keys;

var _dir = [
	_gk.right.isHeld() - _gk.left.isHeld(),
	_gk.down.isHeld() - _gk.up.isHeld(),
];
_dir = VecNormScale(_dir, vel);

x += _dir[0];
y += _dir[1];

if (_gk.confirm.isPressed() && place_meeting(x, y, obj_inimigo)) {
	var enemy = instance_nearest(x, y, obj_inimigo);
	initBattle(enemy.battleData);
}

// TESTE TESTE TIRAR DEPOIS

if (keyboard_check_pressed(vk_f4)) {
	save(1);
}

if (keyboard_check_pressed(vk_f5)) {
	load(1);
}

// SEI LA CARA, TESTE!!!
