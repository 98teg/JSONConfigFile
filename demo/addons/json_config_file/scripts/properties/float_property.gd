extends "./property.gd"

const _FloatValidator := preload("../validators/float_validator.gd")
const _FloatProperty := preload("./float_property.gd")

var _validator := _FloatValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _FloatProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: float) -> _FloatProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _FloatProperty:
	_validator.set_custom_parsing(new_custom_parsing)

	return self


func set_min(new_min: float) -> _FloatProperty:
	_validator.set_min(new_min)

	return self


func set_max(new_max: float) -> _FloatProperty:
	_validator.set_max(new_max)

	return self
