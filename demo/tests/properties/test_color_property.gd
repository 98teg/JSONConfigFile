extends PropertyGutTest


func schema_add_attr():
	return schema.add_color(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"r": 0, "g": 0, "b": 0}, Color.BLACK)
	assert_valid_and_parse_eq({"r": 255, "g": 255, "b": 255}, Color.WHITE)
	assert_valid_and_parse_eq({"r": 255, "g": 0, "b": 0}, Color.RED)
	assert_valid_and_parse_eq({"r": 0, "g": 255, "b": 0}, Color.GREEN)
	assert_valid_and_parse_eq({"r": 0, "g": 0, "b": 255}, Color.BLUE)
	assert_valid_and_parse_eq(
		{"r": 50, "g": 100, "b": 150, "a": 127},
		Color(50 / 255.0, 100 / 255.0, 150 / 255.0, 127 / 255.0)
	)

	assert_invalid_with_wrong_type_msg("#FFFFFF", "object")

	assert_invalid_with_wrong_type_msg({"r": 0.5, "g": 0, "b": 0, "a": 0}, "int", ["r"])
	assert_invalid_with_wrong_type_msg({"r": 0, "g": 0.5, "b": 0, "a": 0}, "int", ["g"])
	assert_invalid_with_wrong_type_msg({"r": 0, "g": 0, "b": 0.5, "a": 0}, "int", ["b"])
	assert_invalid_with_wrong_type_msg({"r": 0, "g": 0, "b": 0, "a": 0.5}, "int", ["a"])

	assert_invalid_with_error_msg(
		{"r": -1, "g": 0, "b": 0, "a": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["r"]
	)
	assert_invalid_with_error_msg(
		{"r": 0, "g": -1, "b": 0, "a": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["g"]
	)
	assert_invalid_with_error_msg(
		{"r": 0, "g": 0, "b": -1, "a": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["b"]
	)
	assert_invalid_with_error_msg(
		{"r": 0, "g": 0, "b": 0, "a": -1},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["a"]
	)

	assert_invalid_with_error_msg(
		{"r": 256, "g": 0, "b": 0, "a": 0},
		"int:more_than_max",
		"256 is more than the maximum allowed (255)",
		{"value": 256, "max": 255},
		["r"]
	)
	assert_invalid_with_error_msg(
		{"r": 0, "g": 256, "b": 0, "a": 0},
		"int:more_than_max",
		"256 is more than the maximum allowed (255)",
		{"value": 256, "max": 255},
		["g"]
	)
	assert_invalid_with_error_msg(
		{"r": 0, "g": 0, "b": 256, "a": 0},
		"int:more_than_max",
		"256 is more than the maximum allowed (255)",
		{"value": 256, "max": 255},
		["b"]
	)
	assert_invalid_with_error_msg(
		{"r": 0, "g": 0, "b": 0, "a": 256},
		"int:more_than_max",
		"256 is more than the maximum allowed (255)",
		{"value": 256, "max": 255},
		["a"]
	)


func test_default_value():
	schema_add_attr().set_default_value(Color.RED)

	assert_has_default_value(Color.RED)


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Color) -> Color: return value.darkened(0.25))

	assert_valid_and_parse_eq({"r": 255, "g": 255, "b": 255}, Color(0.75, 0.75, 0.75))
