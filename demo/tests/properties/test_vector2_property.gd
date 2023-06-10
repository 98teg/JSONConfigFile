extends PropertyGutTest


func schema_add_attr():
	return schema.add_vector2(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"x": 0, "y": 0}, Vector2(0, 0))
	assert_valid_and_parse_eq({"x": 0.0, "y": 0.0}, Vector2(0, 0))
	assert_valid_and_parse_eq({"x": 1.1, "y": 2.2}, Vector2(1.1, 2.2))

	assert_invalid_with_wrong_type_msg("x=0;y=0", "object")

	assert_invalid_with_wrong_type_msg({"x": "0", "y": 0}, "float", ["x"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": "0"}, "float", ["y"])


func test_default_value():
	schema_add_attr().set_default_value(Vector2.ONE)

	assert_has_default_value(Vector2.ONE)


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Vector2) -> Vector2: return Vector2(
		value.x * 2,
		value.y * 2,
	))

	assert_valid_and_parse_eq({"x": 1.1, "y": 2.2}, Vector2(2.2, 4.4))


func test_min():
	schema_add_attr().set_min(Vector2.ZERO)

	assert_valid({"x": 0, "y": 0})
	assert_valid({"x": 10, "y": 10})

	assert_invalid_with_error_msg(
		{"x": -0.1, "y": 0},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": -0.1},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["y"]
	)


func test_max():
	schema_add_attr().set_max(Vector2.ZERO)

	assert_valid({"x": 0, "y": 0})
	assert_valid({"x": -10, "y": -10})

	assert_invalid_with_error_msg(
		{"x": 0.1, "y": 0},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0.1},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["y"]
	)
