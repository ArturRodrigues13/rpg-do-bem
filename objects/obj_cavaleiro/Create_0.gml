defs = new Defs({
	name: "knight",
	element: Element.EARTH,
	vida: 10,
	energy: 10,
	ataque: 2,
	ataquemagico: 1,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: .3,
	danoCrit: 2.5,
	speed: 1,
	actions: 
	[
	{
		name: "basic attack",
		cost: 0,
		desc: "ATAQUE PADRÃO NIBA",
		type: ActionType.ATTACK,
		element: Element.EARTH,
		damageType: DamageType.PHYSICAL,
		targetScope: TargetScope.ENEMY_SINGLE,
		onUse: function (_target, _user) {
			Dano(_user, _user.defs.ataque, _target, damageType, element);
			
			incrementStatus(_target, Status.POISON, 3);
		}
	},
		
	{
		name: "ataque de espada",
		cost: 5,
		desc: "Caua falou pra usar isso",
		type: ActionType.SPELL,
		element: Element.EARTH,
		damageType: DamageType.PHYSICAL,
		targetScope: TargetScope.ENEMY_ALL,
		onUse: function (_target, _user) {
			_user.image_angle += 180;
			DanoAll(_user, 5 * _user.defs.ataque, global.battle.enemies, damageType, element)
		}, 
	}
	],
	
	deathSprite: spr_morto,
	
	
	acessorios: [],
	equipamento: {
		arma: undefined,
		amuleto: undefined,
		vestimenta: undefined,
	},
});
