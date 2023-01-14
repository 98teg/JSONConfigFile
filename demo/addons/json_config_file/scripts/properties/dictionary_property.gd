extends "./property.gd"

const _DictionaryValidator := preload("../validators/dictionary_validator.gd")
const _DictionaryProperty := preload("./dictionary_property.gd")

var _validator := _DictionaryValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _DictionaryProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: Dictionary) -> _DictionaryProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_schema(new_schema: JSONSchema) -> _DictionaryProperty:
	_validator.set_schema(new_schema)

	return self
