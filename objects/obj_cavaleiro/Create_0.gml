defs = new Defs({
	nome: "knight",
	element: Element.EARTH,
	type: Type.VAMPIRE,
	vida: 10,
	ataque: 1,
	ataquemagico: 1,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: .3,
	danoCrit: 2.5,
	speed: 1,
	actions: [{
		name: "basic fire",
		desc: "ATAQUE PADRÃO NIBA",
		type: ActionType.ATTACK,
		element: Element.EARTH,
		damageType: DamageType.PHYSICAL,
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
