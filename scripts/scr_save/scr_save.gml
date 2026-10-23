function save(_file){
	
	// isso aqui é pra permitir vários saves, _file seria o nome, 1 pra o
	// save 1 e etc.
	var saveF = "saveFile" + string(_file) + ".sav";
	
	var invSave = json_stringify(global.inventario);
	show_debug_message(invSave);
	show_debug_message(global.inventario);
	
	var textFile = file_text_open_write(saveF);
	if (textFile != -1) {
		file_text_write_string(textFile, invSave);
		file_text_close(textFile);
	}
}

function load(_file) {
	
	var saveF = "saveFile" + string(_file) + ".sav";
	
	if (file_exists(saveF)) {
		
		var textFile = file_text_open_read(saveF);
		var invLoad = "";
		
		if (textFile != -1) { 
			invLoad = file_text_read_string(textFile); 
			file_text_close(textFile);
		}
		
		show_debug_message(invLoad);
		global.inventario = json_parse(invLoad);
		show_debug_message(global.inventario);
		
		for (var i = 0; i < array_length(global.inventario); i++) {
			if (global.inventario[i] == -4) {
				global.inventario[i] = noone;
			}
		}
		
	} else {
		
		show_debug_message("Erro do mal sei lá");
	}
}