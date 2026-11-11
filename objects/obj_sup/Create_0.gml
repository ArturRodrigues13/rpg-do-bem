defs = new Defs({
	name: "a_slop",
	elements: [Element.WIND],
	vida: 20,
	energy: 1,
	ataque: 1,
	ataquemagico: 3,
	defesa: 2,
	defesamagica: 2,
	chanceCrit: .1,
	danoCrit: 10000,
	speed: 1,
	actions: [{
		name: "basic fire",
		cost: 0,
		desc: "ATAQUE PADRÃO NIBA",
		type: ActionType.ATTACK,
		element: Element.WIND,
		damageType: DamageType.MAGIC,
		targetScope: TargetScope.ENEMY_SINGLE,
		onUse: function (_target, _user) {
			Dano(_user, _user.defs.ataquemagico, _target, damageType, element);
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