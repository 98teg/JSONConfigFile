extends "./property.gd"

const _JSONConfigFileValidator := preload("../validators/json_config_file_validator.gd")
const _JSONConfigFileProperty := preload("./json_config_file_property.gd")

var _validator := _JSONConfigFileValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _JSONConfigFileProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Dictionary) -> _JSONConfigFileProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_schema(new_schema: JSONSchema) -> _JSONConfigFileProperty:
	_validator.set_schema(new_schema)

	return self
