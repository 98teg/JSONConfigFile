extends "./property.gd"

const _Vector3Validator := preload("../validators/vector3_validator.gd")
const _Vector3Property := preload("./vector3_property.gd")

var _validator := _Vector3Validator.new()
var _default_value = null


func set_required(new_required: bool) -> _Vector3Property:
	_required = new_required

	return self


func set_default_value(new_default_value: Vector3) -> _Vector3Property:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _Vector3Property:
	_validator.set_custom_parsing(new_custom_parsing)

	return self


func set_min(new_min: Vector3) -> _Vector3Property:
	_validator.set_min(new_min)

	return self


func set_max(new_max: Vector3) -> _Vector3Property:
	_validator.set_max(new_max)

	return self
