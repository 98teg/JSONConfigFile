class_name JSONProperty


const PRECISION_ERROR = 0.00001


enum Types {
	BOOL,
	NUMBER,
	INTEGER,
	PERCENTAGE,
	STRING,
	ENUM,
	ARRAY,
	COLOR,
	OBJECT,
	FILE,
	JSON_CONFIG_FILE,
	IMAGE,
}


enum Errors {
	COULD_NOT_OPEN_FILE,
	COULD_NOT_OPEN_IMAGE,
	EMPTY_FILE,
	JSON_PARSING_ERROR,
	WRONG_TYPE,
	NUMBER_VALUE_LESS_THAN_MIN,
	NUMBER_VALUE_MORE_THAN_MAX,
	PERCENTAGE_LESS_THAN_ZERO,
	PERCENTAGE_MORE_THAN_ONE,
	STRING_SHORTER_THAN_MIN,
	STRING_LONGER_THAN_MAX,
	STRING_DO_NOT_MATCH_PATTERN,
	ENUM_NOT_VALID,
	ARRAY_SMALLER_THAN_MIN,
	ARRAY_BIGGER_THAN_MAX,
	ARRAY_TWO_ELEMENTS_ARE_EQUAL,
	COLOR_WRONG_SIZE,
	COLOR_WRONG_TYPE,
	COLOR_OUT_OF_RANGE,
	OBJECT_MISSING_PROPERTY,
	OBJECT_NON_VALID_PROPERTY,
	OBJECT_ONE_IS_REQUIRED,
	OBJECT_EXCLUSIVITY_ERROR,
	OBJECT_DEPENDENCY_ERROR,
}


var _result
var _errors := []
var _warnings := []
var _public_variables := {}
var _private_variables := {}
var _preprocessor := JSONConfigProcessor.new()
var _postprocessor := JSONConfigProcessor.new()


func get_result() -> Dictionary:
	return _result


func has_errors() -> bool:
	return _errors.size() != 0


func get_errors() -> Array:
	return _errors


func has_warnings() -> bool:
	return _warnings.size() != 0


func get_warnings() -> Array:
	return _warnings


func set_preprocessor(processor: JSONConfigProcessor) -> void:
	_preprocessor = processor


func set_postprocessor(processor: JSONConfigProcessor) -> void:
	_postprocessor = processor


func _validate(parent: JSONProperty, property) -> void:
	_reset_result()
	_copy_variables(parent)
	_init_processors()

	_preprocessor._process(property)

	if not has_errors():
		_validate_type(property)

	if not has_errors():
		_result = _postprocessor._process(get_result())


func _reset() -> void:
	_reset_result()
	_public_variables.clear()
	_private_variables.clear()


func _reset_result() -> void:
	_result = null
	_errors.clear()
	_warnings.clear()


func _copy_variables(parent: JSONProperty) -> void:
	_public_variables = parent._public_variables
	_private_variables = parent._private_variables


func _init_processors() -> void:
	_preprocessor._set_property(self)
	_postprocessor._set_property(self)


func _validate_type(property) -> void:
	_result = property


func _set_variable(name: String, value) -> void:
	_private_variables[name] = value


func _get_variable(name: String):
	if _private_variables.has(name):
		return _private_variables[name]
	else:
		return null


func _get_file_path(file: String) -> String:
	if file.is_abs_path() or _get_variable("dir_path") == null:
		return file
	else:
		return _get_variable("dir_path").plus_file(file)
