extends PropertyGutTest


func schema_add_attr():
	return schema.add_json_config_file(attr_key)


func test_default_property():
	schema_add_attr()

	set_json_config_file_path("res://tests/properties/files/imaginary.json")

	assert_valid_and_parse_eq(
		"res://tests/properties/files/json_config_file.json",
		{"id": 1.0},
	)
	assert_valid_and_parse_eq("./invalid_json_config_file.json", {"id": "1"})

	assert_invalid_with_wrong_type_msg(12345, "file_path")
	assert_invalid_with_error_msg(
		"./not_found_json_config_file.json",
		"file_path:could_not_open_file",
		(
			"Could not open file at: %s [ERR_FILE_NOT_FOUND]"
			% ProjectSettings.globalize_path(
				"res://tests/properties/files/not_found_json_config_file.json"
			)
		),
		{
			"path":
			ProjectSettings.globalize_path(
				"res://tests/properties/files/not_found_json_config_file.json"
			),
			"code": ERR_FILE_NOT_FOUND,
			"code_as_string": "ERR_FILE_NOT_FOUND",
		}
	)


func test_default_value():
	schema_add_attr().set_default_value({"id": -1})

	assert_has_default_value({"id": -1})


func test_schema():
	var nested_schema := JSONSchema.new()
	nested_schema.add_int("id")
	schema_add_attr().set_schema(nested_schema)

	assert_valid("./json_config_file.json")

	assert_invalid_with_wrong_type_msg("./invalid_json_config_file.json", "int", ["id"])
