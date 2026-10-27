function save(_file){
	
	// isso aqui é pra permitir vários saves, _file seria o nome, 1 pra o
	// save 1 e etc.
	var saveF = "saveFile" + string(_file) + ".sav";
	
	var _fd = file_text_open_write(saveF);
	
	saveAll(_fd);
	
	file_text_close(_fd);
	
}

function saveAll(_fd) {
	
	var _save = json_stringify({inv: global.inventario, binga:"eugosto"});
	
	file_text_write_string(_fd, _save);
}

function load(_file) {
	
	var saveF = "saveFile" + string(_file) + ".sav";
	
	if (file_exists(saveF)) {
		
		var _fd = file_text_open_read(saveF);
		
		loadAll(_fd);
		
		file_text_close(_fd);
		
	} else {
		
		show_debug_message("Erro do mal sei lá");
	}
}

function loadAll(_fd) {
	
	var _load = file_text_read_string(_fd);
	
	_load = json_parse(_load);
	
	global.inventario = _load.inv;
	
	show_debug_message(_load.binga);
}