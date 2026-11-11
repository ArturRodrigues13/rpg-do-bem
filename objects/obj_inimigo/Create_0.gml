defs = new Defs({
	name: "caolho",
	elements: [Element.FIRE],
	vida: 5,
	energy: 1,
	ataque: 1,
	ataquemagico: 6,
	defesa: 0,
	defesamagica: 1,
	chanceCrit: .3,
	danoCrit: 2,
	speed: .5,
	actions: [
		{
			name: "basic fire",
			cost: 0,
			desc: "ATAQUE PADRÃO NIBA",
			type: ActionType.ATTACK,
			element: Element.FIRE,
			damageType: DamageType.MAGIC,
			targetScope: TargetScope.ALLY_SINGLE,
			onUse: function (_target, _user) {
				Dano(_user, _user.defs.ataquemagico, _target, damageType, element);
				
				_target.defs.skipAction = true;
			}
		}
	],
	deathSprite: spr_morto,
	acessorios: [],
});

// slop do mal só pra jogar o mesmo inimigo multiplas vezes aq
var battleEnemies = [];
for (var i = 0; i < 6; i++) {
	array_push(battleEnemies, obj_inimigo);
}

battleData = {
	enemies: battleEnemies,
};
