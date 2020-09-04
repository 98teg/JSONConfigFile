class_name JSONConfigFile


var _configuration := JSONPropertyObject.new()
var _preprocessing_errors = null


func add_property(name: String, property: JSONProperty,
		required := true, default_value = null):
	_configuration.add_property(name, property, required, default_value)


func add_exclusivity(exclusive_properties: Array,
		one_is_required := false) -> bool:
	return _configuration.add_exclusivity(exclusive_properties, one_is_required)


func add_dependency(main_property: String, dependent_property: String) -> bool:
	return _configuration.add_dependency(main_property, dependent_property)


func get_result() -> Dictionary:
	return _configuration.get_result()


func has_errors() -> bool:
	if _preprocessing_errors != null:
		return _preprocessing_errors.size() != 0
	return _configuration.has_errors()


func get_errors() -> Array:
	if _preprocessing_errors != null:
		return _preprocessing_errors
	return _configuration.get_errors()


func validate(file_path : String) -> void:
	_preprocessing_errors = null

	var file = File.new()
	var error = file.open(file_path, File.READ)
	if error != OK:
		_preprocessing_errors = []
		_preprocessing_errors.append({
			"error": JSONProperty.Errors.COULD_NOT_OPEN_FILE,
			"code": error,
		})
		_configuration._reset()
		return

	var text = file.get_as_text()
	if text == "":
		_preprocessing_errors = []
		_preprocessing_errors.append({
			"error": JSONProperty.Errors.EMPTY_FILE,
		})
		_configuration._reset()
		return

	var json = JSON.parse(text)
	error = json.get_error()
	if error != OK:
		_preprocessing_errors = []
		_preprocessing_errors.append({
			"error": JSONProperty.Errors.JSON_PARSING_ERROR,
			"code": error,
			"line": json.get_error_line(),
			"string": json.get_error_string(),
		})
		_configuration._reset()
		return

	_configuration._set_variable("dir_path", file_path.get_base_dir())
	_configuration.validate(_configuration, json.get_result())
