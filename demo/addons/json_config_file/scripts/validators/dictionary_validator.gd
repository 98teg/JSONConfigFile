extends "./validator.gd"

const _DictionaryValidator := preload("./dictionary_validator.gd")

const _type_name := "object"

var _schema: JSONSchema
var _schema_enabled := false


func set_custom_parsing(new_custom_parsing: Callable) -> _DictionaryValidator:
	_custom_parsing = new_custom_parsing

	return self


func set_schema(new_schema: JSONSchema) -> _DictionaryValidator:
	_schema = new_schema
	_schema_enabled = true

	return self


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_DICTIONARY:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	if _schema_enabled:
		msgs.append_array(_schema._validate(value))

	return msgs


func _parse(value: Variant) -> Dictionary:
	if _schema_enabled:
		return _schema._parse(value)

	return value
