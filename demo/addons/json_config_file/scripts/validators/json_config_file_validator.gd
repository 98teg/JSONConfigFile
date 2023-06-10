extends "./validator.gd"

const _JSONConfigFileValidator := preload("./json_config_file_validator.gd")

const _type_name := "file_path"

var _json_config_file := JSONConfigFile.new()
var _schema: JSONSchema = null 


func _init():
	_requires_json_config_file_path = true


func set_schema(new_schema: JSONSchema) -> _JSONConfigFileValidator:
	_schema = new_schema

	return self


func _validate(value: Variant, json_config_file_path: String) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_STRING:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	_json_config_file.parse(_path(value, json_config_file_path), _schema)
	
	return _json_config_file.get_all_messages()


func _parse(value: Variant, json_config_file_path: String) -> Dictionary:
	_json_config_file.parse(_path(value, json_config_file_path), _schema)
	
	return _json_config_file.data


static func _path(value: Variant, json_config_file_path: String) -> String:
	var dir := json_config_file_path.get_base_dir()
	var path := dir.path_join(value) if value.is_relative_path() else value

	return ProjectSettings.globalize_path(path).simplify_path()
