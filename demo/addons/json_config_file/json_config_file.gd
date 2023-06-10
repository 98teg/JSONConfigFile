extends Object
class_name JSONConfigFile

const _ValidationMsg := preload("./scripts/validation_msg.gd")
const _FileAccessValidator := preload("./scripts/validators/file_access_validator.gd")

const _type_name := "json_config_file"

var data = null

var _msgs: Array[_ValidationMsg] = []


func get_all_messages() -> Array[_ValidationMsg]:
	return _msgs


func get_error_messages() -> Array[_ValidationMsg]:
	return get_all_messages().filter(_msg_filter(_ValidationMsg.Importance.ERROR))


func get_warning_messages() -> Array[_ValidationMsg]:
	return get_all_messages().filter(_msg_filter(_ValidationMsg.Importance.WARNING))


func get_all_messages_as_text() -> Array[String]:
	var msgs: Array[String] = []
	for msg in get_all_messages():
		msgs.append(msg.as_text())
	return msgs


func get_error_messages_as_text() -> Array[String]:
	var msgs: Array[String] = []
	for msg in get_error_messages():
		msgs.append(msg.as_text())
	return msgs


func get_warning_messages_as_text() -> Array[String]:
	var msgs: Array[String] = []
	for msg in get_warning_messages():
		msgs.append(msg.as_text())
	return msgs


func parse(path: String, schema: JSONSchema = null, ignore_warnings := true) -> Error:
	_msgs = _validate(path, schema)

	if ignore_warnings:
		if get_error_messages().size() > 0:
			return FAILED
	else:
		if get_all_messages().size() > 0:
			return FAILED

	data = JSON.parse_string(FileAccess.get_file_as_string(path))

	if schema != null:
		data = schema._parse(data, path)

	return OK


static func parse_path(path: String, schema: JSONSchema = null, ignore_warnings := true):
	var msgs = _validate(path, schema)

	if ignore_warnings:
		if msgs.filter(_msg_filter(_ValidationMsg.Importance.ERROR)).size() > 0:
			return null
	else:
		if msgs.size() > 0:
			return null

	var data = JSON.parse_string(FileAccess.get_file_as_string(path))

	if schema != null:
		data = schema._parse(data, path)

	return data


static func _validate(path: String, schema: JSONSchema = null) -> Array[_ValidationMsg]:
	var file_access_validator = _FileAccessValidator.new()
	var msgs = file_access_validator._validate_with_custom_validation(path.get_file(), path)

	if not msgs.is_empty():
		return msgs

	var file := file_access_validator._parse_with_path(path.get_file(), path)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		if schema != null:
			msgs = schema._validate(json.data, path)

		return msgs

	return [_json_parse_error(json.get_error_message(), json.get_error_line())]


static func _msg_filter(importance: int) -> Callable:
	return func(msg: _ValidationMsg):
		return msg.importance == _ValidationMsg.Importance.ERROR


static func _json_parse_error(message: String, line: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":json_parse_error",
		"JSON Parse Error: %s at line %d" % [message, line],
		{"message": message, "line": line}
	)
