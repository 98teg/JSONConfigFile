extends GutTest

enum Gender {
	MALE,
	FEMALE,
	NON_BINARY,
}

const ValidationMsg := preload("res://addons/json_config_file/scripts/validation_msg.gd")

var json_config_file: JSONConfigFile


func before_each():
	json_config_file = JSONConfigFile.new()


func test_default_behaviour():
	assert_valid_and_parse_eq(
		"res://tests/files/person.json",
		null,
		{
			"name": "Mr Person",
			"age": 42.0,
			"gender": "MALE",
			"telephone_number": "123 456 789",
			"address":
			{
				"street": "Long Street",
				"number": 7.0,
			},
			"parent": "./parent.json",
		}
	)

	assert_invalid_with_error_msg_as_text(
		"res://tests/files/not_found_person.json",
		null,
		(
			"Could not open file at: %s [ERR_FILE_NOT_FOUND]."
			% ProjectSettings.globalize_path("res://tests/files/not_found_person.json")
		)
	)

	assert_invalid_with_error_msg_as_text(
		"res://tests/files/invalid.json", null, "JSON Parse Error: Unterminated String at line 11.",
	)


func test_schema():
	var person_schema := JSONSchema.new()

	person_schema.add_string("name")

	person_schema.add_int("age")

	person_schema\
		.add_enum("gender")\
		.add_value("MALE", Gender.MALE)\
		.add_value("FEMALE", Gender.FEMALE)\
		.add_value("NON_BINARY", Gender.NON_BINARY)

	person_schema.add_string("telephone_number").set_pattern("^( |[0-9])+$")

	var addess_schema := JSONSchema.new()
	addess_schema.add_string("street")
	addess_schema.add_int("number")
	person_schema.add_dictionary("address").set_schema(addess_schema)

	person_schema.add_json_config_file("parent").set_required(false).set_schema(person_schema)

	assert_valid_and_parse_eq(
		"res://tests/files/person.json",
		person_schema,
		{
			"name": "Mr Person",
			"age": 42,
			"gender": Gender.MALE,
			"telephone_number": "123 456 789",
			"address":
			{
				"street": "Long Street",
				"number": 7,
			},
			"parent":
			{
				"name": "Ms Parent",
				"age": 73,
				"gender": Gender.FEMALE,
				"telephone_number": "987 654 321",
				"address":
				{
					"street": "Short Street",
					"number": 11,
				},
			},
		}
	)

	assert_invalid_with_error_msgs_as_text(
		"res://tests/files/invalid_person.json",
		person_schema,
		[
			"Wrong type: expected 'string', at 'name'.",
			"Wrong type: expected 'int', at 'age'.",
			"Wrong type: expected 'string', at 'gender'.",
			"Wrong type: expected 'string', at 'telephone_number'.",
			"Wrong type: expected 'string', at 'address.street'.",
			"Wrong type: expected 'int', at 'address.number'.",
			"Wrong type: expected 'int', at 'parent.age'.",
			"'MADAM' is not a valid value, at 'parent.gender'.",
			(
				"'invalid telephone number' does not match the specified pattern: /^( |[0-9])+$/"
				+ ", at 'parent.telephone_number'."
			),
			"Wrong type: expected 'int', at 'parent.address.number'.",
		]
	)


func assert_valid_and_parse_eq(path: String, schema: JSONSchema, expected_value: Dictionary):
	assert_eq(JSONConfigFile.parse_path(path, schema), expected_value)
	assert_eq(json_config_file.parse(path, schema), OK)
	assert_eq(json_config_file.data, expected_value)


func assert_invalid_with_error_msg_as_text(path: String, schema: JSONSchema, msg_as_text: String):
	assert_invalid_with_error_msgs_as_text(path, schema, [msg_as_text])


func assert_invalid_with_error_msgs_as_text(
	path: String,
	schema: JSONSchema,
	msgs_as_text: Array[String]
):
	assert_eq(JSONConfigFile.parse_path(path, schema), null)
	assert_eq(json_config_file.parse(path, schema), FAILED)
	assert_eq(json_config_file.get_all_messages().size(), msgs_as_text.size())

	for i in range(json_config_file.get_all_messages().size()):
		assert_eq(json_config_file.get_all_messages_as_text()[i], msgs_as_text[i])
