lastImage = sprite_get_number(defs.deathSprite) - 1;

if (defs.isDown()) {
	if (image_index >= lastImage) image_speed = 0;
}