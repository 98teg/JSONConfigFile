extends PropertyGutTest


func schema_add_attr():
	return schema.add_vector2i(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"x": 0, "y": 0}, Vector2i(0, 0))
	assert_valid_and_parse_eq({"x": 0.0, "y": 0.0}, Vector2i(0, 0))
	assert_valid_and_parse_eq({"x": 10, "y": 20}, Vector2i(10, 20))

	assert_invalid_with_wrong_type_msg("x=0;y=0", "object")

	assert_invalid_with_wrong_type_msg({"x": "0", "y": 0}, "int", ["x"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": "0"}, "int", ["y"])


func test_default_value():
	schema_add_attr().set_default_value(Vector2i.ONE)

	assert_has_default_value(Vector2i.ONE)


func test_min():
	schema_add_attr().set_min(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0})
	assert_valid({"x": 10, "y": 10})

	assert_invalid_with_error_msg(
		{"x": -1, "y": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": -1},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["y"]
	)


func test_max():
	schema_add_attr().set_max(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0})
	assert_valid({"x": -10, "y": -10})

	assert_invalid_with_error_msg(
		{"x": 1, "y": 0},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 1},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["y"]
	)
