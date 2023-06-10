extends "./property.gd"

const _ColorValidator := preload("../validators/color_validator.gd")
const _ColorProperty := preload("./color_property.gd")

var _validator := _ColorValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _ColorProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Color) -> _ColorProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _ColorProperty:
	_validator.set_custom_parsing(new_custom_parsing)

	return self
