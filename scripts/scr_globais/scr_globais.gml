randomise();

// Combate

global.partyAliada = [];
global.partyInimiga = [];

global.info = [];

function VecDotNormalized(_v1, _v2) {
	return dot_product_normalised(_v1[0], _v1[1], _v2[0], _v2[1]);
}
	
function VecDot(_v1, _v2) {
	return dot_product(_v1[0], _v1[1], _v2[0], _v2[1]);
}

function VecAdd(_v1, _v2) {
    return [_v1[0] + _v2[0], _v1[1] + _v2[1]];
}

function VecSub(_v1, _v2) {
    return [_v1[0] - _v2[0], _v1[1] - _v2[1]];
}

function VecDist(_v1, _v2) {
	return VecLen(VecSub(_v1, _v2));
}

function VecLen(_v1) {
	return sqrt(_v1[0] * _v1[0] + _v1[1] * _v1[1]);
}

function VecNotEmpty(_v1) {
	return _v1[0] != 0.0 || _v1[1] != 0.0;
}
