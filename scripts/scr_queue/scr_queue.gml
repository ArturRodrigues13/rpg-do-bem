function Queue(_init=undefined) constructor {
	arr = (_init != undefined) ? _init : [];

	isEmpty = function() {
		return array_length(arr) == 0;
	}

	put = function(_x) {
		array_push(arr, _x);
	}

	peek = function() {
		return arr[0];
	}

	get = function() {
		var ret = arr[0];
		dequeue();
		return ret;
	}

	dequeue = function() {
		array_delete(arr, 0, 1);
	}
}
