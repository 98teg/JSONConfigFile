extends PropertyGutTest


func schema_add_attr():
	return schema.add_int(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq(0, 0)
	assert_valid_and_parse_eq(0.0, 0)
	assert_valid_and_parse_eq(9223372036854775807, 9223372036854775807)
	assert_valid_and_parse_eq(-9223372036854775807, -9223372036854775807)

	assert_invalid_with_wrong_type_msg("0", "int")
	assert_invalid_with_wrong_type_msg(0.5, "int")


func test_default_value():
	schema_add_attr().set_default_value(1)

	assert_has_default_value(1)


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: int) -> int: return value * 2)

	assert_valid_and_parse_eq(2, 4)


func test_min():
	schema_add_attr().set_min(0)

	assert_valid(0)
	assert_valid(9223372036854775807)

	assert_invalid_with_error_msg(
		-1, "int:less_than_min", "-1 is less than the minimum allowed (0)", {"value": -1, "min": 0}
	)


func test_max():
	schema_add_attr().set_max(0)

	assert_valid(0)
	assert_valid(-9223372036854775807)

	assert_invalid_with_error_msg(
		1, "int:more_than_max", "1 is more than the maximum allowed (0)", {"value": 1, "max": 0}
	)
