extends PropertyGutTest


func schema_add_attr():
	return schema.add_float(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq(0, 0.0)
	assert_valid_and_parse_eq(0.0, 0.0)
	assert_valid_and_parse_eq(3.14, 3.14)
	assert_valid_and_parse_eq(-1.212, -1.212)

	assert_invalid_with_wrong_type_msg("0", "float")


func test_default_value():
	schema_add_attr().set_default_value(1.23)

	assert_has_default_value(1.23)


func test_min():
	schema_add_attr().set_min(0.0)

	assert_valid(0)
	assert_valid(17.3)

	assert_invalid_with_error_msg(
		-0.1,
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0}
	)


func test_max():
	schema_add_attr().set_max(0.0)

	assert_valid(0)
	assert_valid(-2.4)

	assert_invalid_with_error_msg(
		0.1,
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0}
	)
