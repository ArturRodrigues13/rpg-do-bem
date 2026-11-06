function InventoryMenu(_stack) : Menu(_stack) constructor {
	choices = ["Equipamentos", "Acessórios", "Consumíveis", "Geral"];

	onChoice = function() {
		if (choiceIdx == 0) {
			stack.push(new ArmoryInventoryMenu(stack));
		} else if (choiceIdx == 1) {
			stack.push(new AccessoryInventoryMenu(stack));
		} else if (choiceIdx == 2){
			stack.push(new UsableInventoryMenu(stack));
		} else {
			show_debug_message("ué");
		}
	}
	
	onDraw = function() {
		
		var rw = room_width;
		var rh = room_height;
		var borderOffX = 30;
		var borderOffY = 40;
		
		draw_set_colour(c_aqua);
		draw_rectangle(borderOffX, borderOffY, rw - borderOffX, rh - borderOffY, false);
		draw_set_colour(c_white);
		
		for(var i = 0; i < array_length(choices); i++) {
			
			if(choiceIdx == i) draw_set_colour(c_yellow);
			draw_text(borderOffX + 100 * i, borderOffY + 20, choices[i]);
			draw_set_colour(c_white);
		}
	}
	
	handleInput = function() {
		
		var _gk = global.keys;

		if (_gk.right.isPressed()) choiceIdx++;
		if (_gk.left.isPressed()) choiceIdx--;
			
		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.inventory.isPressed() && allowBack) stack.pop();
	}
}

function UsableInventoryMenu(_stack) : Menu(_stack) constructor {
	
}

function AccessoryInventoryMenu(_stack) : Menu(_stack) constructor {
	
}

function ArmoryInventoryMenu(_stack) : Menu(_stack) constructor {
	
}

