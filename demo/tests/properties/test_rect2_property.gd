extends PropertyGutTest


func schema_add_attr():
	return schema.add_rect2(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"x": 0, "y": 0, "w": 0, "h": 0}, Rect2(0, 0, 0, 0))
	assert_valid_and_parse_eq({"x": 0.0, "y": 0.0, "w": 0.0, "h": 0.0}, Rect2(0, 0, 0, 0))
	assert_valid_and_parse_eq(
		{"x": 1.1, "y": 2.2, "w": -1.1, "h": -2.2}, Rect2(1.1, 2.2, -1.1, -2.2)
	)

	assert_invalid_with_wrong_type_msg("x=0;y=0;w=0;h=0", "object")

	assert_invalid_with_wrong_type_msg({"x": "0", "y": 0, "w": 0, "h": 0}, "float", ["x"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": "0", "w": 0, "h": 0}, "float", ["y"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": 0, "w": "0", "h": 0}, "float", ["w"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": 0, "w": 0, "h": "0"}, "float", ["h"])


func test_default_value():
	schema_add_attr().set_default_value(Rect2(0, 0, 1, 1))

	assert_has_default_value(Rect2(0, 0, 1, 1))


func test_min_position():
	schema_add_attr().set_min_position(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": 10, "y": 10, "w": 10, "h": 10})
	assert_valid({"x": 0.1, "y": 0.1, "w": -1, "h": -1})

	assert_invalid_with_error_msg(
		{"x": -0.1, "y": 0, "w": 0, "h": 0},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": -0.1, "w": 0, "h": 0},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["y"]
	)


func test_max_position():
	schema_add_attr().set_max_position(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": -10, "y": -10, "w": -10, "h": -10})
	assert_valid({"x": -0.1, "y": -0.1, "w": 1, "h": 1})

	assert_invalid_with_error_msg(
		{"x": 0.1, "y": 0, "w": 0, "h": 0},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0.1, "w": 0, "h": 0},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["y"]
	)


func test_min_size():
	schema_add_attr().set_min_size(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": 10, "y": 10, "w": 10, "h": 10})
	assert_valid({"x": -1, "y": -1, "w": 0.1, "h": 0.1})

	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": -0.1, "h": 0},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["w"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": 0, "h": -0.1},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["h"]
	)


func test_max_size():
	schema_add_attr().set_max_size(Vector2i.ZERO)

	assert_valid({"x": 0, "y": 0, "w": 0, "h": 0})
	assert_valid({"x": -10, "y": -10, "w": -10, "h": -10})
	assert_valid({"x": 1, "y": 1, "w": -0.1, "h": -0.1})

	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": 0.1, "h": 0},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["w"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "w": 0, "h": 0.1},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["h"]
	)
