function getDamageIcon(_damageType) {
	
	if(_damageType == DamageType.MAGIC) {
		return spr_magicIcon;
	} else if (_damageType == DamageType.PHYSICAL) {
		return spr_physicalIcon;
	} else {
		return spr_truthIcon;
	}
}

function getElementIcon(_elementType) {
	
	return global.elementIcons[_elementType];
}