extends "./property.gd"

const _Vector2iValidator := preload("../validators/vector2i_validator.gd")
const _Vector2iProperty := preload("./vector2i_property.gd")

var _validator := _Vector2iValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _Vector2iProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Vector2i) -> _Vector2iProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min(new_min: Vector2i) -> _Vector2iProperty:
	_validator.set_min(new_min)

	return self


func set_max(new_max: Vector2i) -> _Vector2iProperty:
	_validator.set_max(new_max)

	return self
