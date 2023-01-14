extends "./validator.gd"

const _type_name := "boolean"


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_BOOL:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	return []


func _parse(value: Variant) -> bool:
	return value
