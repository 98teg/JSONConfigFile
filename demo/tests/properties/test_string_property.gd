extends PropertyGutTest


func schema_add_attr():
	return schema.add_string(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq("test", "test")
	assert_valid_and_parse_eq("godot is awesome", "godot is awesome")

	assert_invalid_with_wrong_type_msg(0, "string")


func test_default_value():
	schema_add_attr().set_default_value("empty")

	assert_has_default_value("empty")


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: String) -> String: return "custom " + value)

	assert_valid_and_parse_eq("string", "custom string")


func test_min():
	schema_add_attr().set_min(1)

	assert_valid(".")
	assert_valid("Hello")

	assert_invalid_with_error_msg(
		"",
		"string:shorter_than_min",
		"''s length is shorter than the minimum length allowed (1)",
		{"value": "", "min_length": 1}
	)


func test_max():
	schema_add_attr().set_max(10)

	assert_valid("")
	assert_valid("Goodbye")

	assert_invalid_with_error_msg(
		"A String that is too long",
		"string:longer_than_max",
		"'A String that is too long's length is longer than the maximum length allowed (10)",
		{"value": "A String that is too long", "max_length": 10}
	)


func test_pattern():
	schema_add_attr().set_pattern("^#([A-Fa-f0-9]{6})$")

	assert_valid("#ab01CD")
	assert_valid("#2e3F45")

	assert_invalid_with_error_msg(
		"Not valid hex Color",
		"string:unmatched_pattern",
		"'Not valid hex Color' does not match the specified pattern: /^#([A-Fa-f0-9]{6})$/",
		{"value": "Not valid hex Color", "pattern": "^#([A-Fa-f0-9]{6})$"}
	)
