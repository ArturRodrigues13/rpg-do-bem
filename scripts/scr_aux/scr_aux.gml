function getDamageIcon(_damageType) {
	
	if(_damageType == DamageType.MAGIC) {
		return spr_magicIcon;
	} else if (_damageType == DamageType.PHYSICAL) {
		return spr_physicalIcon;
	} else {
		return spr_truthIcon;
	}
}

function getTargetIcon(_targetScope) {
	
	if(_targetScope == TargetScope.ALLY_SINGLE) {
		return spr_scopeAlly;
	} else if (_targetScope == TargetScope.ALLY_ALL) {
		return spr_scopeAllyAll;
	} else if (_targetScope == TargetScope.ENEMY_SINGLE) {
		return spr_scopeEnemy;
	} else if (_targetScope == TargetScope.ENEMY_ALL) {
		return spr_scopeEnemyAll;
	} else {
		return spr_scopeSelf;
	}
}

function getElementIcon(_elementType) {
	
	if(_elementType == Element.FIRE) {
		return spr_elementFire
	} else if (_elementType == Element.WATER) {
		return spr_elementWater
	} else if (_elementType == Element.WIND) {
		return spr_elementWind
	} else if (_elementType == Element.EARTH) {
		return spr_elementEarth
	} else if (_elementType == Element.ELECTRICAL) {
		return spr_scopeAllyAll;
	} else if (_elementType == Element.NATURE) {
		return spr_scopeAllyAll;
	} else if (_elementType == Element.MACHINE) {
		return spr_scopeAllyAll;
	} else if (_elementType == Element.HOLY) {
		return spr_scopeAllyAll;
	} else {
		return undefined;
	}
}

