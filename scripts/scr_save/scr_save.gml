function save(_file){
	
	// isso aqui é pra permitir vários saves, _file seria o nome, 1 pra o
	// save 1 e etc.
	var saveF = "saveFile" + string(_file) + ".sav";
	
	ini_open(saveF);
	
	saveInventory();
	
	ini_close();
	
}

function saveInventory() {
	
	var IDs = array_map(global.inventario, function(_x) {
		if(_x != noone) return _x.ID;
			
			return noone
		}
	);
	
	var invSave = json_stringify(IDs);
	
	ini_write_string("Inventário", "Consumíveis", invSave);
}

function load(_file) {
	
	var saveF = "saveFile" + string(_file) + ".sav";
	
	if (file_exists(saveF)) {
		
		ini_open(saveF);
		
		loadInventory();
		
		ini_close();
		
	} else {
		
		show_debug_message("Erro do mal sei lá");
	}
}

function loadInventory() {
	
	var invLoad = ini_read_string("Inventário", "Consumíveis", []);
	
	invLoad = json_parse(invLoad);
	
	for(var i = 0; i < array_length(invLoad); i++) {
		
		if(invLoad[i] != -4) {
			
			var item = searchItem(invLoad[i]);
			
			global.inventario[i] = item;
		} else {
			
			global.inventario[i] = noone;
		}
	}
}