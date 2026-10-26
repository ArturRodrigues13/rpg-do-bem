defs = new Definedefs(5, 1, 2, 0, 1, 1, TypeDamage.MAGIC, .3, 2, []);

infoLuta = [];
for (var _i = 0; _i < 6; _i++) {
	// slop do mal só pra jogar o mesmo inimigo multiplas vezes aq
	array_push(infoLuta, { obj: obj_inimigo });
}

// seja lá qual for o sprite de morte, colocar ele aqui
deathSprite = spr_morto;

lastImage = sprite_get_number(deathSprite) - 1;
