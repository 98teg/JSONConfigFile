class_name JSONPropertyJSONConfigFile
extends JSONProperty


var _json_config_file:= JSONConfigFile.new()


func set_json_config_file(json_config_file: JSONConfigFile) -> void:
	_json_config_file = json_config_file


func _validate_type(config) -> void:
	if typeof(config) == TYPE_DICTIONARY:
		_result = config
	elif typeof(config) == TYPE_STRING:
		var config_path

		if config.is_abs_path():
			config_path = config
		else:
			config_path = _dir_path.plus_file(config)

		_json_config_file.validate(config_path)

		for error in _json_config_file.get_errors():
			_errors.append(error)

		_result = _json_config_file.get_result()
	else:
		_errors.append({
			"error": Errors.WRONG_TYPE,
			"expected": Types.JSON_CONFIG_FILE,
		})
