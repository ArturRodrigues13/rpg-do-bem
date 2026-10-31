defs = new Defs({
	nome: "mago",
	element: Element.WATER,
	type: Type.VAMPIRE,
	vida: 5,
	ataque: 1,
	ataquemagico: 10,
	defesa: 0,
	defesamagica: 5,
	chanceCrit: .1,
	danoCrit: 2,
	speed: 1.5,
	actions: [{
		name: "basic fire",
		desc: "ATAQUE PADRÃO NIBA",
		type: ActionType.ATTACK,
		element: Element.WATER,
		damageType: DamageType.MAGIC,
		targetType: TargetScope.EnemySingle,
		onUse: function (_target, _user) {
			Ataque(_user, _target, damageType, element);
		}
	}],
	deathSprite: spr_morto,
	
	acessorios: [],
	equipamento: {
		arma: undefined,
		amuleto: undefined,
		vestimenta: undefined,
	},
	
	deathSprite: spr_morto,
});
