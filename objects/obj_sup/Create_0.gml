defs = new Defs({
	nome: "slop",
	element: Element.WIND,
	type: Type.VAMPIRE,
	vida: 20,
	ataque: 1,
	ataquemagico: 3,
	defesa: 2,
	defesamagica: 2,
	chanceCrit: .1,
	danoCrit: 10000,
	speed: 1,
	actions: [{
		name: "basic fire",
		desc: "ATAQUE PADRÃO NIBA",
		type: ActionType.ATTACK,
		element: Element.WIND,
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
});