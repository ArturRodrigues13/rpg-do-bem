function InventoryMenu(_stack) : Menu(_stack) constructor {
	choices = ["Equipamentos", "Acessórios", "Consumíveis"];

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
		var originIconsX = borderOffX + 33;
		var originIconsY = borderOffY + 30;
		var offsetIcons = 97;
		var subimg = 0;
		var iconSprites = [spr_armoryItensIcon, spr_accessoryItensIcon, spr_usableItensIcon];
		
		// Fundo preto opaco
		draw_set_alpha(.7);
		draw_set_colour(c_black);
		draw_rectangle(0, 0, rw, rh, false);
		draw_set_alpha(1);
		draw_set_colour(c_white);
		
		draw_set_colour(c_aqua);
		draw_rectangle(borderOffX, borderOffY, rw - borderOffX, rh - borderOffY, false);
		draw_set_colour(c_white);
		
		for(var i = 0; i < array_length(choices); i++) {
			
			subimg = choiceIdx == i ? 1 : 0;
			draw_sprite(iconSprites[i] , subimg, originIconsX + offsetIcons * i, originIconsY);
		}
	}
	
	handleInput = function() {
		
		var _gk = global.keys;

		if (_gk.right.isPressed()) choiceIdx++;
		if (_gk.left.isPressed()) choiceIdx--;
			
		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.inventory.isPressed() or _gk.back.isPressed()) stack.pop();
	}
}

function UsableInventoryMenu(_stack) : Menu(_stack) constructor {
	choices = global.inventory;
	ncols = 4;

	onDraw = function() {
		
		var holding = global.invHeldItem == undefined ? false : true;
		var heldItem = global.invHeldItem;
		
		var rw = room_width;
		var rh = room_height;

		// Fundo preto opaco
		draw_set_alpha(.7);
		draw_set_colour(c_black);
		draw_rectangle(0, 0, rw, rh, false);
		draw_set_alpha(1);
		draw_set_colour(c_white);
		
		var invX = 80;
		var invY = 15;

		draw_sprite(spr_inventory, choiceIdx, invX, invY);
		
		var originX = invX + 28;
		var originY = invY + 24;
		var offX = 56;
		var offY = 42;

		for (var i = 0; i < 12; i++) {

			var ix = i mod ncols;
			var iy = i div ncols;

			var _leftX = originX + ix * offX;
			var _topY = originY + iy * offY;

			if (choices[i] != undefined) {
				var itemInfo = global.itensData[$ choices[i]];
				
				if(heldItem != undefined && heldItem == i) draw_set_alpha(.5);
				draw_sprite(itemInfo.spr, 0, _leftX, _topY);
				
			}
			
			if(choiceIdx == i && heldItem != undefined) {
				draw_set_alpha(.5);
				draw_sprite(global.itensData[$ choices[heldItem]].spr, 0, _leftX + 10, _topY - 10);
			}
			draw_set_alpha(1);
			
		}

		if (choices[choiceIdx] != undefined && !holding) {
			var itemInfo = global.itensData[$ choices[choiceIdx]];
			draw_set_colour(c_green);
			draw_rectangle(10, rh - 64, rw - 10, rh - 5, false);
			draw_set_colour(c_white);

			draw_text(15, rh - 60, itemInfo.name);
			draw_text(15, rh - 45, itemInfo.desc);
		}
	}

	handleInput = function() {
		var _gk = global.keys;
		var _dimX = 4;
		var _dimY = 3;
		var _dirX = _gk.right.isPressed() - _gk.left.isPressed();
		var _dirY = _gk.down.isPressed() - _gk.up.isPressed();
		var _x = clamp((choiceIdx mod _dimX) + _dirX, 0, _dimX - 1);
		var _y = clamp((choiceIdx div _dimX) + _dirY, 0, _dimY - 1);
		choiceIdx = _y * _dimX + _x;

		if (_gk.confirm.isPressed()) onChoice();
		if (_gk.back.isPressed()){
			stack.pop();
			global.invHeldItem = undefined;
		} 
	}

	onChoice = function() {
		if(global.invHeldItem == undefined) {
			if(choices[choiceIdx] != undefined) global.invHeldItem = choiceIdx;
		} else {
			if(choices[choiceIdx] == undefined) {
				choices[choiceIdx] = choices[global.invHeldItem];
				choices[global.invHeldItem] = undefined;
				global.invHeldItem = undefined;
				
			} else {
				var temp = choices[choiceIdx];
				choices[choiceIdx] = choices[global.invHeldItem];
				choices[global.invHeldItem] = temp;
				global.invHeldItem = undefined;
			}
		}
	}
}

function AccessoryInventoryMenu(_stack) : Menu(_stack) constructor {
	
}

function ArmoryInventoryMenu(_stack) : Menu(_stack) constructor {
	
}

