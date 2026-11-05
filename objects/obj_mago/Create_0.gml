defs = new Defs({
	name: "mago",
	element: Element.WATER,
	vida: 5,
	energy: 100,
	ataque: 1,
	ataquemagico: 10,
	defesa: 0,
	defesamagica: 5,
	chanceCrit: .1,
	danoCrit: 2,
	speed: 1.5,
	actions: 
	[
		{
			name: "basic water",
			desc: "Acerta um inimigo com uma lapada de agua do bem, buft, ficou fodido!",
			type: ActionType.ATTACK,
			element: Element.WATER,
			damageType: DamageType.MAGIC,
			targetScope: TargetScope.ENEMY_SINGLE,
			onUse: function (_target, _user) {
				Ataque(_user, _target, damageType, element);
			}
		},
		
		{
			name: "no basic",
			desc: "eu cago na rua 1",
			type: ActionType.ATTACK,
			element: Element.WIND,
			damageType: DamageType.PHYSICAL,
			targetScope: TargetScope.ENEMY_SINGLE,
			onUse: function (_target, _user) {
				Ataque(_user, _target, damageType, element);
			}
		},
		
		{
			name: "super basic",
			desc: "eu cago na rua 2",
			type: ActionType.ATTACK,
			element: Element.EARTH,
			damageType: DamageType.TRUTH,
			targetScope: TargetScope.ENEMY_SINGLE,
			onUse: function (_target, _user) {
				Ataque(_user, _target, damageType, element);
			}
		},
		
		{
			name: "basic???",
			desc: "bom dia gente, como ces ta em?",
			type: ActionType.ATTACK,
			element: Element.WATER,
			damageType: DamageType.MAGIC,
			targetScope: TargetScope.ENEMY_SINGLE,
			onUse: function (_target, _user) {
				Ataque(_user, _target, damageType, element);
			}
		},
	],
	deathSprite: spr_morto,
	
	acessorios: [],
	equipamento: {
		arma: undefined,
		amuleto: undefined,
		vestimenta: undefined,
	},
	
	deathSprite: spr_morto,
});
