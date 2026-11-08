/// @desc Dados de inicialização da batalha.
global.battleData = undefined;

// _attacker pode ser undefined
function Dano(_attacker, _baseDamage, _target, _typeD, _element) {
	
	var mult = 0;
	
	if(_attacker != undefined) {
		var atDefs = _attacker.defs;
		mult = (random(1) <= atDefs.chanceCrit) ? atDefs.danoCrit : 1;
	} else {
		mult = 1;
	}
	
	var dano = _baseDamage;
	
	dano *= global.dmgTable[_element][_target.defs.element];

	if (_typeD == DamageType.PHYSICAL) {
		dano = max(0, (dano * mult) - _target.defs.defesa);
	} else if (_typeD == DamageType.MAGIC) {
		dano = max(0, (dano * mult) - _target.defs.defesamagica);
	}

	_target.defs.vida -= dano;

	checkDeath(_target);
}

function DanoAll(_attacker, _baseDamage, _alvos, _typeD, element) {
	for (var i = 0; i < array_length(_alvos); i++) {
		if (!_alvos[i].defs.isDown()) Dano(_attacker, _baseDamage, _alvos[i], _typeD, element);
	}
}

/// @desc Inicializa uma batalha, preparando os objetos e indo para a cena de batalha.
/// @param {Struct} _data Dados da batalha
/// @param {Array} _data.enemies Lista de inimigos que estarão presentes na batalha
function initBattle(_data) {
	global.battleData = _data;
	room_goto(rm_testeLuta);
}

function Battle(_args) constructor {
	args = _args;
	allyIdx = 0;
	timeStep = 0.1;
	actionCounter = 0.0;
	actionQueue = new Queue();

	/// @desc Desenha barras de progresso de ações.
	drawStepBattleProgressBar = function() {
		// BARRA DO PROGRESSO GERAL:
		var bar_width = 100;
		var bar_height = 15;
		var bar_x = 10;
		var bar_y = 10;

		var progress = actionCounter / 1;
		var current_bar_width = bar_width * progress;

		draw_set_color(c_gray);
		draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

		draw_set_color(c_red);
		draw_rectangle(bar_x, bar_y, bar_x + current_bar_width, bar_y + bar_height, false);

		// BARRA DOS PERSONAGENS
		for (var i = 0; i < array_length(battleInstances); i++) {
			var inst = battleInstances[i];
			if (inst.defs.isDown()) continue;
			drawCharacterStepBar(inst.defs, inst.x, inst.y);	
		}
	}
	
	// @desc Desenhar info da batalha, apenas pra evitar fazer battle.funçãoX várias vezes
	drawBattleInfo = function () {
		
		drawStepBattleProgressBar();
		drawStatusIcons(battleInstances);
	}

	/// @desc Avança o tempo da batalha e analisa o que precisa ser feito.
	stepBattleTime = function() {
		if (!actionQueue.isEmpty()) {
			// tem coisas acontecendo, não avançar o tempo
			return;
		}

		// Às vezes duas coisas podem chegar na contagem ao mesmo tempo. Mas, por causa da ordem do código aqui, se não tivermos cuidado, há uma hierarquia exata para quem vai conseguir agir primeiro.
		// Por causa disso, vamos fazer o seguinte:
		// 1. Acumular todas as ações pendentes em uma lista;
		// 2. Embaralhar os elementos;
		// 3. Ordenar (estável) pelo valor do counter, crescente;
		// 4. Adicionar da esquerda para a direita na fila;
		var acc = [];

		actionCounter += timeStep;
		if (actionCounter >= 1) {
			actionCounter -= 1;
			array_push(acc, { source: "moment", counter: actionCounter });
		}

		for (var i = 0; i < array_length(enemies); i++) {
			var d = enemies[i].defs;

			if (d.isDown()) continue;
			var thr = d.getActionThreshold();

			d.actionCounter += timeStep;
			if (d.actionCounter >= thr) {
				d.actionCounter -= thr;
				array_push(acc, { source: "enemy", idx: i, counter: d.actionCounter });
			}
		}

		for (var i = 0; i < array_length(allies); i++) {
			var d = allies[i].defs;

			if (d.isDown()) continue;
			var thr = d.getActionThreshold();

			d.actionCounter += timeStep;
			if (d.actionCounter >= thr) {
				d.actionCounter -= thr;
				array_push(acc, { source: "ally", idx: i, counter: d.actionCounter });
			}
		}

		// Embaralhar, ordenar e colocar na fila
		array_shuffle_ext(acc);
		arraySortStableExt(acc, function(_a, _b) {
			var ac = _a.counter;
			var bc = _b.counter;
			if (ac < bc) return 1;
			if (ac > bc) return -1;
			return 0;
		});
		for (var i = 0; i < array_length(acc); i++) {
			actionQueue.put(acc[i]);
		}
	}

	/// @desc Instancia objetos em uma grade (ordem row-first) com as dimensões especificadas.
	/// @param {Array} _objs Objetos a serem instanciados na batalha.
	/// @param {Array} _origin Vetor de posição do primeiro objeto (topo-esquerda).
	/// @param {Array} _offset Vetor de offset para cada objeto adicionado.
	/// @param {Real} _ncols Número de colunas na grade.
	/// @returns A lista de objetos devidamente instanciados.
	instObjGrid = function(_objs, _origin, _offsets, _ncols) {
		// TODO: aceitar layouts mais complexos (não necessariamente uma matriz seca)

		var ret = [];
		var ox = _origin[0];
		var oy = _origin[1];
		for (var i = 0; i < array_length(_objs); i++) {
			// decompondo índice em linha-coluna
			var row = i div _ncols;
			var col = i mod _ncols;

			var inst = instance_create_layer(ox + col * _offsets[0], oy + row * _offsets[1], "Instances", _objs[i]);
			array_push(ret, inst);
		}
		return ret;
	}

	// inicializando arrays & grids de aliados e inimigos
	allies = instObjGrid(
		array_map(args.allyNames, function(_x) { return global.allyData[$ _x].obj; }),
		[40, 50], [80, 50], 2);
	enemies = instObjGrid(args.enemies, [200, 25], [120, 40], 2);
	
	battleInstances = array_concat(allies, enemies);

	/// @desc Faz um inimigo específico realizar uma ação aleatória em seu banco de ações.
	enemyRandomAction = function(_enemy) {
		if (array_length(allies) == 0) return;

		var actions = _enemy.defs.actions;
		if (array_length(actions) == 0) return;

		var targetIdx = irandom(array_length(allies) - 1);
		var actionIdx = irandom(array_length(actions) - 1);
		actions[actionIdx].onUse(allies[targetIdx], _enemy);
	}
}

// @desc Incrementar N stacks de um certo status num inimigo;
function incrementStatus(_target, _status, _stacks) {
	var statusArray = _target.defs.status;
	_target.defs.status[_status][0] += _stacks;
}

// @desc Aplicar o efeito de um certo status no inimigo, reduzindo seus stacks e
// lidando com o fato de ser ou não a primeira aplicação;
function applyStatus(_target, _status) {
	
	// TODO: Isso tá meio slop, ajeitar depois
	var defs = _target.defs
	var firstApply = false;
	if(defs.status[_status][1] == false) {
		firstApply = true;
		defs.status[_status][1] = true;
	}
	
	defs.status[_status][0] -= 1;
	if(defs.status[_status][0] == 0) {
		defs.status[_status][1] = false;
	}
	
	switch (_status) {
		case Status.BURN:
			defs.vida -= 1;
			// TODO: Pensar numa forma eficiente de lidar com isso de redução de ataque.
			//if(firstApply) defs.ataque -= round(defs.ataque / 2);
			//
			//if(defs.status[_status][0] == 0) defs.ataque += round(defs.ataque / 2);
			
		break;
	
		case Status.POISON:
			defs.vida -= 2;
		break;
	}
	
	checkDeath(_target);
}

// @desc Passar por todas as instâncias em batalha e verificar se eles possuem stacks de algum status;
function checkStatus(_fightInstances) {

	for (var i = 0; i < array_length(_fightInstances); i++) {
		var inst = _fightInstances[i];
		for(var j = 0; j < Status._MAX; j++) {
			if(inst.defs.status[j][0] > 0) {
				applyStatus(inst, j);
			}
		}
	}
}

function checkDeath(_inst) {
	if (_inst.defs.vida <= 0) {
		_inst.sprite_index = _inst.defs.deathSprite;
		_inst.image_index = 0;
	}
}

/// @desc `dmgTable[X][Y]` é o multiplicador de dano quando o elemento X ataca um ser de elemento Y
function initDamageTable() {
	var tbl = [];
	repeat (Element._MAX) {
		var row = [];
		repeat (Element._MAX) {
			array_push(row, 1);
		}
		array_push(tbl, row);
	}  
	
	tbl[Element.WATER][Element.FIRE] = 2;
	
	
	return tbl;
}
dmgTable = initDamageTable();