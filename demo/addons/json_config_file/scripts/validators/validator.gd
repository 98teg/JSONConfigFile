extends Object

const _ValidationMsg := preload("../validation_msg.gd")

var _requires_json_config_file_path := false
var _custom_parsing := func(value: Variant): return value


func _validate_with_custom_validation(
	value: Variant,
	json_config_file_path: String
) -> Array[_ValidationMsg]:
	var msgs: Array[_ValidationMsg] = []
	if _requires_json_config_file_path:
		msgs = _validate_with_path(value, json_config_file_path)
	else:
		msgs = _validate(value)

	return msgs


func _parse_with_custom_parsing(value: Variant, json_config_file_path: String):
	var result
	if _requires_json_config_file_path:
		result = _parse_with_path(value, json_config_file_path)
	else:
		result = _parse(value)

	return _custom_parsing.call(result)


func _validate(value: Variant) -> Array[_ValidationMsg]:
	assert(false, "Please override `_validate` in the derived script.")
	return []


func _validate_with_path(value: Variant, json_config_file_path: String) -> Array[_ValidationMsg]:
	assert(false, "Please override _validate_with_path` in the derived script.")
	return []


func _parse(value: Variant):
	assert(false, "Please override _parse` in the derived script.")
	pass


func _parse_with_path(value: Variant, json_config_file_path: String):
	assert(false, "Please override _parse_with_path` in the derived script.")
	pass
