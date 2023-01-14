extends "./property.gd"

const _BoolValidator := preload("../validators/bool_validator.gd")
const _BoolProperty := preload("./bool_property.gd")

var _validator := _BoolValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _BoolProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: bool) -> _BoolProperty:
	set_required(false)
	_default_value = new_default_value

	return self
