extends PropertyGutTest


func schema_add_attr():
	return schema.add_vector3i(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({"x": 0, "y": 0, "z": 0}, Vector3i(0, 0, 0))
	assert_valid_and_parse_eq({"x": 0.0, "y": 0.0, "z": 0.0}, Vector3i(0, 0, 0))
	assert_valid_and_parse_eq({"x": 10, "y": 20, "z": 30}, Vector3i(10, 20, 30))

	assert_invalid_with_wrong_type_msg("x=0;y=0;z=0", "object")

	assert_invalid_with_wrong_type_msg({"x": "0", "y": 0, "z": 0}, "int", ["x"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": "0", "z": 0}, "int", ["y"])
	assert_invalid_with_wrong_type_msg({"x": 0, "y": 0, "z": "0"}, "int", ["z"])


func test_default_value():
	schema_add_attr().set_default_value(Vector3i.ONE)

	assert_has_default_value(Vector3i.ONE)


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Vector3i) -> Vector3i: return Vector3i(
		value.x * 2,
		value.y * 2,
		value.z * 2,
	))

	assert_valid_and_parse_eq({"x": 1, "y": 2, "z": 3}, Vector3i(2, 4, 6))


func test_min():
	schema_add_attr().set_min(Vector3i.ZERO)

	assert_valid({"x": 0, "y": 0, "z": 0})
	assert_valid({"x": 10, "y": 10, "z": 10})

	assert_invalid_with_error_msg(
		{"x": -1, "y": 0, "z": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": -1, "z": 0},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["y"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "z": -1},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["z"]
	)


func test_max():
	schema_add_attr().set_max(Vector3i.ZERO)

	assert_valid({"x": 0, "y": 0, "z": 0})
	assert_valid({"x": -10, "y": -10, "z": -10})

	assert_invalid_with_error_msg(
		{"x": 1, "y": 0, "z": 0},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["x"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 1, "z": 0},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["y"]
	)
	assert_invalid_with_error_msg(
		{"x": 0, "y": 0, "z": 1},
		"int:more_than_max",
		"1 is more than the maximum allowed (0)",
		{"value": 1, "max": 0},
		["z"]
	)
