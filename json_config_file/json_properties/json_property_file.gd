class_name JSONPropertyFile
extends JSONProperty


func _validate_type(file) -> void:
	if file is File:
		_result = file
	elif typeof(file) == TYPE_STRING:
		var file_path

		if file.is_abs_path():
			file_path = file
		else:
			file_path = _dir_path.plus_file(file)

		var result = File.new()
		var error = result.open(file_path, File.READ)
		if error != OK:
			_errors.append({
				"error": JSONProperty.Errors.COULD_NOT_OPEN_FILE,
				"code": error,
			})
		else:
			_result = result
	else:
		_errors.append({
			"error": Errors.WRONG_TYPE,
			"expected": Types.FILE,
		})
