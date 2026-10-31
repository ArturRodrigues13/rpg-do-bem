defs = new Defs({
	nome: "caolho",
	element: Element.FIRE,
	type: Type.VAMPIRE,
	vida: 5,
	ataque: 1,
	ataquemagico: 6,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: .3,
	danoCrit: 2,
	speed: .5,
	actions: [{
		name: "basic fire",
		desc: "ATAQUE PADRÃO NIBA",
		type: ActionType.ATTACK,
		element: Element.FIRE,
		damageType: DamageType.MAGIC,
		targetType: TargetScope.AllySingle,
		onUse: function (_target, _user) {
			Ataque(_user, _target, damageType, element);
		}
	}],
	deathSprite: spr_morto,
	
	acessorios: [],
});

infoLuta = [];

for (var i = 0; i < 6; i++) {
	// slop do mal só pra jogar o mesmo inimigo multiplas vezes aq
	array_push(infoLuta, { obj: obj_inimigo });
}