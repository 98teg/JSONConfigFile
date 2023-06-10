extends PropertyGutTest


func schema_add_attr():
	return schema.add_rect2i(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"x": 0, "y": 0, "w": 0, "h": 0}, Rect2i(0, 0, 0, 0))
	assert_valid_and_parse_eq({"x": 0.0, "y": 0.0, "w": 0.0, "h": 0.0}, Rect2i(0, 0, 0, 0))
	assert_valid_and_parse_eq({"x": 10, "y": 20, "w": -10, "h": -20}, Rect2i(10, 20, -10, -20))

	assert_invalid_with_wrong_type_msg("x=0;y=0;w=0;h=0", "object")

	assert_invalid_with_wrong_type_msg({"x": "0", "y": 0, "w": 0, "h": 0}, "int", ["x"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": "0", "w": 0, "h": 0}, "int", ["y"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": 0, "w": "0", "h": 0}, "int", ["w"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": 0, "w": 0, "h": "0"}, "int", ["h"])


func test_default_value():
	schema_add_attr().set_default_value(Rect2i(0, 0, 1, 1))

	assert_has_default_value(Rect2i(0, 0, 1, 1))


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Rect2i) -> Rect2i: return Rect2i(
		value.position.x * 2,
		value.position.y * 2,
		value.size.x * 2,
		value.size.y * 2,
	))

	assert_valid_and_parse_eq({"x": 1, "y": 2, "w": 3, "h": 4}, Rect2i(2, 4, 6, 8))


func test_min_position():
	schema_add_attr().set_min_position(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": 10, "y": 10, "w": 10, "h": 10})
	assert_valid({"x": 0, "y": 0, "w": -1, "h": -1})

	assert_invalid_with_error_msg(
		{"x": -1, "y": 0, "w": 0, "h": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": -1, "w": 0, "h": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["y"]
	)


func test_max_position():
	schema_add_attr().set_max_position(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": -10, "y": -10, "w": -10, "h": -10})
	assert_valid({"x": 0, "y": 0, "w": 1, "h": 1})

	assert_invalid_with_error_msg(
		{"x": 1, "y": 0, "w": 0, "h": 0},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 1, "w": 0, "h": 0},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["y"]
	)


func test_min_size():
	schema_add_attr().set_min_size(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": 10, "y": 10, "w": 10, "h": 10})
	assert_valid({"x": -1, "y": -1, "w": 0, "h": 0})

	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": -1, "h": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["w"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": 0, "h": -1},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["h"]
	)


func test_max_size():
	schema_add_attr().set_max_size(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": -10, "y": -10, "w": -10, "h": -10})
	assert_valid({"x": 1, "y": 1, "w": 0, "h": 0})

	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": 1, "h": 0},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["w"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": 0, "h": 1},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["h"]
	)
