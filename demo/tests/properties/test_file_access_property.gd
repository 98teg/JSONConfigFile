extends PropertyGutTest


func schema_add_attr():
	return schema.add_file_access(attr_key)


func test_default_property():
	schema_add_attr()

	assert_invalid_with_wrong_type_msg(12345, "file_path")


func test_default_value():
	var file_access = FileAccess.open("res://tests/properties/files/text_file.txt", FileAccess.READ)
	schema_add_attr().set_default_value(file_access)

	assert_has_default_value(file_access)


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: FileAccess) -> String:
		return value.get_as_text().get_slice("\n", 0)
	)

	set_json_config_file_path("res://tests/properties/files/imaginary.json")

	assert_valid_and_parse_eq(
		"res://tests/properties/files/text_file.txt",
		"This is a text file used for testing purposes."
	)


func test_open():
	schema_add_attr()

	set_json_config_file_path("res://tests/properties/files/imaginary.json")

	assert_valid("res://tests/properties/files/text_file.txt")
	assert_valid("./text_file.txt")

	assert_invalid_with_error_msg(
		"./not_found_text_file.txt",
		"file_path:could_not_open_file",
		(
			"Could not open file at: %s [ERR_FILE_NOT_FOUND]"
			% ProjectSettings.globalize_path("res://tests/properties/files/not_found_text_file.txt")
		),
		{
			"path":
			ProjectSettings.globalize_path("res://tests/properties/files/not_found_text_file.txt"),
			"code": ERR_FILE_NOT_FOUND,
			"code_as_string": "ERR_FILE_NOT_FOUND",
		}
	)


func test_open_compressed():
	schema_add_attr().set_open_compressed(FileAccess.COMPRESSION_GZIP)

	set_json_config_file_path("res://tests/properties/files/imaginary.json")

	assert_valid("res://tests/properties/files/compressed_text_file.lol")
	assert_valid("./compressed_text_file.lol")

	assert_invalid_with_error_msg(
		"./text_file.txt",
		"file_path:could_not_open_file",
		(
			"Could not open file at: %s [ERR_FILE_UNRECOGNIZED]"
			% ProjectSettings.globalize_path("res://tests/properties/files/text_file.txt")
		),
		{
			"path": ProjectSettings.globalize_path("res://tests/properties/files/text_file.txt"),
			"code": ERR_FILE_UNRECOGNIZED,
			"code_as_string": "ERR_FILE_UNRECOGNIZED",
		}
	)


func test_open_encrypted():
	schema_add_attr().set_open_encrypted(range(1, 33))

	set_json_config_file_path("res://tests/properties/files/imaginary.json")

	assert_valid("res://tests/properties/files/encrypted_text_file.lol")
	assert_valid("../files/encrypted_text_file.lol")

	assert_invalid_with_error_msg(
		"./encrypted_with_pass_text_file.lol",
		"file_path:could_not_open_file",
		(
			"Could not open file at: %s [ERR_FILE_CORRUPT]"
			% ProjectSettings.globalize_path(
				"res://tests/properties/files/encrypted_with_pass_text_file.lol"
			)
		),
		{
			"path":
			ProjectSettings.globalize_path(
				"res://tests/properties/files/encrypted_with_pass_text_file.lol"
			),
			"code": ERR_FILE_CORRUPT,
			"code_as_string": "ERR_FILE_CORRUPT",
		}
	)


func test_open_encrypted_with_pass():
	schema_add_attr().set_open_encrypted_with_pass("password")

	set_json_config_file_path("res://tests/properties/files/imaginary.json")

	assert_valid("res://tests/properties/files/encrypted_with_pass_text_file.lol")
	assert_valid("../../properties/files/encrypted_with_pass_text_file.lol")

	assert_invalid_with_error_msg(
		"./encrypted_text_file.lol",
		"file_path:could_not_open_file",
		(
			"Could not open file at: %s [ERR_FILE_CORRUPT]"
			% ProjectSettings.globalize_path("res://tests/properties/files/encrypted_text_file.lol")
		),
		{
			"path":
			ProjectSettings.globalize_path("res://tests/properties/files/encrypted_text_file.lol"),
			"code": ERR_FILE_CORRUPT,
			"code_as_string": "ERR_FILE_CORRUPT",
		}
	)
