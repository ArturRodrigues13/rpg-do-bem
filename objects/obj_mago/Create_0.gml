defs = new Defs({
	name: "mago",
	element: Element.WATER,
	vida: 5,
	energy: 5,
	ataque: 1,
	ataquemagico: 1,
	defesa: 0,
	defesamagica: 5,
	chanceCrit: .1,
	danoCrit: 2,
	speed: 1.5,
	actions: 
	[
		{
			name: "basic water",
			cost: 0,
			desc: "Acerta um inimigo com uma lapada de agua do bem, buft, ficou fodido!",
			type: ActionType.ATTACK,
			element: Element.WATER,
			damageType: DamageType.MAGIC,
			targetScope: TargetScope.ENEMY_SINGLE,
			onUse: function (_target, _user) {
				Dano(_user, _user.defs.ataquemagico, _target, damageType, element);
				
				incrementStatus(_target, Status.BURN, 3);
			}
		},
		
		{
			name: "cura aliado",
			cost: 10,
			desc: "cura um aliado, duh",
			type: ActionType.SPELL,
			element: Element.WATER,
			damageType: DamageType.MAGIC,
			targetScope: TargetScope.ALLY_SINGLE,
			onUse: function (_target, _user) {
				_target.defs.vida += _user.defs.ataquemagico;
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
