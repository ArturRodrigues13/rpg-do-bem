var dir_h, dir_v, left, right, up, down;

right = keyboard_check(vk_right);
left = keyboard_check(vk_left);
up = keyboard_check(vk_up);
down = keyboard_check(vk_down);

dir_h = (right - left);
dir_v = (down - up);

x += dir_h * vel;

y += dir_v * vel

var inimigo = place_meeting(x, y, obj_inimigo);

if(inimigo && keyboard_check_pressed(vk_enter)) {

	global.info = inimigo.infoLuta;
	room_goto(rm_testeLuta);
}