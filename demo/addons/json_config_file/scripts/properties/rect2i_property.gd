extends "./property.gd"

const _Rect2iValidator := preload("../validators/rect2i_validator.gd")
const _Rect2iProperty := preload("./rect2i_property.gd")

var _validator := _Rect2iValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _Rect2iProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Rect2i) -> _Rect2iProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _Rect2iProperty:
	_validator.set_custom_parsing(new_custom_parsing)

	return self


func set_min_position(new_min_position: Vector2i) -> _Rect2iProperty:
	_validator.set_min_position(new_min_position)

	return self


func set_max_position(new_max_position: Vector2i) -> _Rect2iProperty:
	_validator.set_max_position(new_max_position)

	return self


func set_min_size(new_min_size: Vector2i) -> _Rect2iProperty:
	_validator.set_min_size(new_min_size)

	return self


func set_max_size(new_max_size: Vector2i) -> _Rect2iProperty:
	_validator.set_max_size(new_max_size)

	return self
