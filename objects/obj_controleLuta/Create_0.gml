enum turno {
	ALIADOS,
	INIMIGOS
}

enum estado {
	ESCOLHENDO,
	ATACAR,
	ITEM,
	FUGIR
}

setinhaX = 0;
setinhaY = 0;
setinhaTargetX = 0;
setinhaTargetY = 0;

atacantes = turno.ALIADOS;
estado_atual = estado.ESCOLHENDO;
indice_escolha = 0;
indice_aliados = 0;
opcoes = ["ATACAR", "ITEM", "FUGIR"];


setInimigos(global.partyInimiga, global.info);
setAliados(global.partyAliada);

alvo = 0;

function BuscarAlvo(_dir) {

	var inimigos = global.info;
	if (array_length(inimigos) == 0) return;
	alvo = clamp(alvo, 0, array_length(inimigos) - 1);
	var posAtual = inimigos[alvo].pos;
	var cand = [];
	
	for (var i = 0; i < array_length(inimigos); i++) {
		if (i == alvo) continue;
		
		var ii = inimigos[i];
		var dp = VecDotNormalized(VecSub(ii.pos, posAtual), _dir);
		if (dp >= 0.25) array_push(cand, { dot: dp, idx: i, pos: ii.pos });
	}
	array_sort(cand, function(_a, _b) { return sign(_a.dot - _b.dot); });
	
	if (array_length(cand) == 0) return;
	
	var maiorDot = array_last(cand).dot;
	var menorDist = VecDist(posAtual, array_last(cand).pos);
	var maisProx = array_length(cand) - 1;
	for (var i = array_length(cand) - 2; i > 0 && cand[i].dot == maiorDot; i--) {
		var dist = VecDist(posAtual, cand[i].pos);
		if (dist < menorDist) {
			menorDist = dist;
			maisProx = i;
		}
	}
	
	alvo = cand[maisProx].idx;
}
