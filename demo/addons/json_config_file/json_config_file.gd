extends Object
class_name JSONConfigFile

const _ValidationMsg := preload("./scripts/validation_msg.gd")
const _FileAccessValidator := preload("./scripts/validators/file_access_validator.gd")

const _type_name := "json_config_file"

var data = null

var _schema := JSONSchema.new()
var _schema_enabled := false
var _file_access_validator = _FileAccessValidator.new()
var _msgs: Array[_ValidationMsg] = []


func set_schema(new_schema: JSONSchema) -> void:
	_schema = new_schema
	enable_schema()


func get_schema() -> JSONSchema:
	return _schema


func enable_schema() -> void:
	_schema_enabled = true


func disable_schema() -> void:
	_schema_enabled = false


func get_all_messages() -> Array[_ValidationMsg]:
	return _msgs


func get_error_messages() -> Array[_ValidationMsg]:
	return _msgs.filter(
		func(msg: _ValidationMsg): return msg.importance == _ValidationMsg.Importance.ERROR
	)


func get_warning_messages() -> Array[_ValidationMsg]:
	return _msgs.filter(
		func(msg: _ValidationMsg): return msg.importance == _ValidationMsg.Importance.WARNING
	)


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


func parse(path: String, ignore_warnings := true) -> Error:
	_validate(path)

	if ignore_warnings:
		if get_error_messages().size() > 0:
			return FAILED
	else:
		if get_all_messages().size() > 0:
			return FAILED

	data = JSON.parse_string(FileAccess.get_file_as_string(path))

	if _schema_enabled:
		data = _schema._parse(data, path)

	return OK


func _validate(path: String) -> void:
	_msgs = _file_access_validator._validate(path.get_file(), path)

	if not _msgs.is_empty():
		return

	var file := _file_access_validator._parse(path.get_file(), path)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		if _schema_enabled:
			_msgs = _schema._validate(json.data, path)

		return

	_msgs = [_json_parse_error(json.get_error_message(), json.get_error_line())]


static func _json_parse_error(message: String, line: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":json_parse_error",
		"JSON Parse Error: %s at line %d" % [message, line],
		{"message": message, "line": line}
	)
