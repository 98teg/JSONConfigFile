extends PropertyGutTest

enum Gender {
	MALE,
	FEMALE,
	NON_BINARY,
}


func schema_add_attr():
	return schema.add_enum(attr_key)


func test_default_property():
	schema_add_attr()

	assert_invalid_with_wrong_type_msg(0, "string")


func test_default_value():
	schema_add_attr().set_default_value(Gender.MALE)

	assert_has_default_value(Gender.MALE)


func test_custom_parsing():
	schema_add_attr()\
		.add_value("MALE", Gender.MALE)\
		.add_value("FEMALE", Gender.FEMALE)\
		.add_value("NON_BINARY", Gender.NON_BINARY)\
		.set_custom_parsing(func(value: Gender) -> Gender:
			match(value):
				Gender.MALE:
					return Gender.FEMALE
				Gender.FEMALE:
					return Gender.MALE
			
			return Gender.NON_BINARY
	)

	assert_valid_and_parse_eq("MALE", Gender.FEMALE)
	assert_valid_and_parse_eq("FEMALE", Gender.MALE)
	assert_valid_and_parse_eq("NON_BINARY", Gender.NON_BINARY)


func test_add_value():
	schema_add_attr()\
		.add_value("MALE", Gender.MALE)\
		.add_value("FEMALE", Gender.FEMALE)\
		.add_value("NON_BINARY", Gender.NON_BINARY)

	assert_valid_and_parse_eq("MALE", Gender.MALE)
	assert_valid_and_parse_eq("FEMALE", Gender.FEMALE)
	assert_valid_and_parse_eq("NON_BINARY", Gender.NON_BINARY)

	assert_invalid_with_error_msg(
		"GENTLEMAN",
		"string:not_valid_value",
		"'GENTLEMAN' is not a valid value",
		{"value": "GENTLEMAN"}
	)
