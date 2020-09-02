class_name JSONProperty


const PRECISION_ERROR = 0.00001


enum Types {
	BOOL,
	NUMBER,
	INTEGER,
	PERCENTAGE,
	STRING,
	ARRAY,
	COLOR,
	OBJECT,
	FILE,
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
var _dir_path := ""


func get_result() -> Dictionary:
	return _result


func has_errors() -> bool:
	return _errors.size() != 0


func get_errors() -> Array:
	return _errors


func validate(property) -> void:
	_reset()
	_validate_type(property)

func _validate_type(property) -> void:
	_result = property

func _reset() -> void:
	_result = null
	_errors.clear()

func _set_dir_path(dir_path: String) -> void:
	_dir_path = dir_path
