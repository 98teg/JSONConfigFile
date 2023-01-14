extends "./property.gd"

const _IntValidator := preload("../validators/int_validator.gd")
const _IntProperty := preload("./int_property.gd")

var _validator := _IntValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _IntProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: int) -> _IntProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_min(new_min: int) -> _IntProperty:
	_validator.set_min(new_min)

	return self


func set_max(new_max: int) -> _IntProperty:
	_validator.set_max(new_max)

	return self
