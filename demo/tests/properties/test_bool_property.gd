extends PropertyGutTest


func schema_add_attr():
	return schema.add_bool(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq(true, true)
	assert_valid_and_parse_eq(false, false)

	assert_invalid_with_wrong_type_msg("true", "boolean")


func test_default_value():
	schema_add_attr().set_default_value(true)

	assert_has_default_value(true)
