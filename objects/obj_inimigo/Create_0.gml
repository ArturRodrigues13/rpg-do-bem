defs = new Defs({
	nome: "caolho",
	vida: 5,
	ataque: 1,
	ataquemagico: 6,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: .3,
	danoCrit: 2,
	speed: .5,
	tipoAtaque: DamageType.MAGIC,
	
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
