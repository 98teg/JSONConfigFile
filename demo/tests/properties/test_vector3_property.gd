extends PropertyGutTest


func schema_add_attr():
	return schema.add_vector3(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"x": 0, "y": 0, "z": 0}, Vector3(0, 0, 0))
	assert_valid_and_parse_eq({"x": 0.0, "y": 0.0, "z": 0.0}, Vector3(0, 0, 0))
	assert_valid_and_parse_eq({"x": 1.1, "y": 2.2, "z": 3.3}, Vector3(1.1, 2.2, 3.3))

	assert_invalid_with_wrong_type_msg("x=0;y=0;z=0", "object")

	assert_invalid_with_wrong_type_msg({"x": "0", "y": 0, "z": 0}, "float", ["x"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": "0", "z": 0}, "float", ["y"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": 0, "z": "0"}, "float", ["z"])


func test_default_value():
	schema_add_attr().set_default_value(Vector3.ONE)

	assert_has_default_value(Vector3.ONE)


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Vector3) -> Vector3: return Vector3(
		value.x * 2,
		value.y * 2,
		value.z * 2,
	))

	assert_valid_and_parse_eq({"x": 1.1, "y": 2.2, "z": 3.3}, Vector3(2.2, 4.4, 6.6))


func test_min():
	schema_add_attr().set_min(Vector3.ZERO)

	assert_valid({"x": 0, "y": 0, "z": 0})
	assert_valid({"x": 10, "y": 10, "z": 10})

	assert_invalid_with_error_msg(
		{"x": -0.1, "y": 0, "z": 0},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": -0.1, "z": 0},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["y"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "z": -0.1},
		"float:less_than_min",
		"-0.1 is less than the minimum allowed (0)",
		{"value": -0.1, "min": 0.0},
		["z"]
	)


func test_max():
	schema_add_attr().set_max(Vector3.ZERO)

	assert_valid({"x": 0, "y": 0, "z": 0})
	assert_valid({"x": -10, "y": -10, "z": -10})

	assert_invalid_with_error_msg(
		{"x": 0.1, "y": 0, "z": 0},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0.1, "z": 0},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["y"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "z": 0.1},
		"float:more_than_max",
		"0.1 is more than the maximum allowed (0)",
		{"value": 0.1, "max": 0.0},
		["z"]
	)
