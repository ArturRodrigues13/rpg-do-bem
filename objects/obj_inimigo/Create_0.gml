defs = new Definedefs(5, 1, 0, .3, 2, []);

infoLuta = [
	{obj: obj_inimigo, pos: [-60, -60]},
	{obj: obj_inimigo, pos: [+60, -60]},
	{obj: obj_inimigo, pos: [-60, 0]},
	{obj: obj_inimigo, pos: [+60, 0]},
	{obj: obj_inimigo, pos: [-60, +60]},
	{obj: obj_inimigo, pos: [+60, +60]},
];

// seja lá qual for o sprite de morte, colocar ele aqui
deathSprite = spr_morto;

lastImage = sprite_get_number(deathSprite) - 1;