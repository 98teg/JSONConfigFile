extends "./property.gd"

const _Rect2Validator := preload("../validators/rect2_validator.gd")
const _Rect2Property := preload("./rect2_property.gd")

var _validator := _Rect2Validator.new()
var _default_value = null


func set_required(new_required: bool) -> _Rect2Property:
	_required = new_required

	return self


func set_default_value(new_default_value: Rect2) -> _Rect2Property:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min_position(new_min_position: Vector2) -> _Rect2Property:
	_validator.set_min_position(new_min_position)

	return self


func set_max_position(new_max_position: Vector2) -> _Rect2Property:
	_validator.set_max_position(new_max_position)

	return self


func set_min_size(new_min_size: Vector2) -> _Rect2Property:
	_validator.set_min_size(new_min_size)

	return self


func set_max_size(new_max_size: Vector2) -> _Rect2Property:
	_validator.set_max_size(new_max_size)

	return self
