extends "./property.gd"

const _Vector3iValidator := preload("../validators/vector3i_validator.gd")
const _Vector3iProperty := preload("./vector3i_property.gd")

var _validator := _Vector3iValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _Vector3iProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Vector3i) -> _Vector3iProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min(new_min: Vector3i) -> _Vector3iProperty:
	_validator.set_min(new_min)

	return self


func set_max(new_max: Vector3i) -> _Vector3iProperty:
	_validator.set_max(new_max)

	return self
