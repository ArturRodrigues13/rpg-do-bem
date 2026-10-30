defs = new Defs({
	vida: 5,
	ataque: 1,
	ataquemagico: 2,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: 1,
	tipoAtaque: DamageType.MAGIC,
	danoCrit: 0.3,
	speed: .5,
	acessorios: [],
});

infoLuta = [];

for (var i = 0; i < 6; i++) {
	// slop do mal só pra jogar o mesmo inimigo multiplas vezes aq
	array_push(infoLuta, { obj: obj_inimigo });
}

// seja lá qual for o sprite de morte, colocar ele aqui
deathSprite = spr_morto;

lastImage = sprite_get_number(deathSprite) - 1;
