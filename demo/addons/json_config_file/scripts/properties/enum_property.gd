extends "./property.gd"

const _EnumValidator := preload("../validators/enum_validator.gd")
const _EnumProperty := preload("./enum_property.gd")

var _validator := _EnumValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _EnumProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: int) -> _EnumProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _EnumProperty:
	_validator.set_custom_parsing(new_custom_parsing)

	return self


func add_value(name: StringName, value: int) -> _EnumProperty:
	_validator.add_value(name, value)

	return self
