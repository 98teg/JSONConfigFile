extends "./property.gd"

const _Vector2Validator := preload("../validators/vector2_validator.gd")
const _Vector2Property := preload("./vector2_property.gd")

var _validator := _Vector2Validator.new()
var _default_value = null


func set_required(new_required: bool) -> _Vector2Property:
	_required = new_required

	return self


func set_default_value(new_default_value: Vector2) -> _Vector2Property:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _Vector2Property:
	_validator.set_custom_parsing(new_custom_parsing)

	return self


func set_min(new_min: Vector2) -> _Vector2Property:
	_validator.set_min(new_min)

	return self


func set_max(new_max: Vector2) -> _Vector2Property:
	_validator.set_max(new_max)

	return self
