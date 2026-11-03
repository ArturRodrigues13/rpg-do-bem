function MenuStack() constructor {
	stack = [];

	/// @param {Menu} _menu O menu a ser adicionado
	push = function(_menu) {
		array_push(stack, _menu);
	}

	pop = function() {
		return array_pop(stack);
	}

	peek = function() {
		return array_last(stack);
	}

	isEmpty = function() {
		return array_length(stack) == 0;
	}

	/// @desc Tira o menu atual da pilha e passa `_data` para o pai, se presente.
	confirmAndPop = function(_data) {
		pop();
		if (!isEmpty()) {
			peek().onConfirmSignal(_data);
		}
	}
}

/// @param {MenuStack} _stack
function Menu(_stack) constructor {
	stack = _stack;
	choices = [];
	choiceIdx = 0;
	allowBack = true;

	onStep = function() {
		handleInput();
		choiceIdx = clamp(choiceIdx, 0, array_length(choices) - 1);
	}

	onDraw = function() {
		var _x = room_width;
		var _y = room_height;

		draw_set_colour(c_green);
		draw_rectangle(0, _y - 50, _x, _y, false);
		draw_set_colour(c_white);

		for (var i = 0; i < array_length(choices); i++) {
			draw_text(40, _y - 70 + 20 * i, choices[i]);

			if (choiceIdx == i) {
				draw_sprite(spr_setinha, 0, 30, _y - 60 + 20 * i);
			}
		}
	}

	handleInput = function() {
		var _gk = global.keys;

		if (_gk.up.isPressed()) choiceIdx--;
		if (_gk.down.isPressed()) choiceIdx++;
		choiceIdx = clamp(choiceIdx, 0, array_length(choices) - 1);

		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.back.isPressed() && allowBack) stack.pop();
	}

	onChoice = function() {
		show_error("not implemented", true);
	}

	/// @desc Roda quando um menu acima deste na pilha é finalizado. Veja `MenuStack.confirmAndPop`.
	/// @param {Any} _data Informação a ser passada para o pai.
	onConfirmSignal = function(_data) {
		// Nessa implementação padrão, não fazer nada; só tirar da pilha e sinalizar pro pai.
		stack.confirmAndPop();
	}
}
