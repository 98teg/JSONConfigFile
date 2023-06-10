extends PropertyGutTest


func schema_add_attr():
	return schema.add_dictionary(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq({}, {})
	assert_valid_and_parse_eq({"id": 1}, {"id": 1})

	assert_invalid_with_wrong_type_msg("id:1", "object")


func test_default_value():
	schema_add_attr().set_default_value({"id": -1})

	assert_has_default_value({"id": -1})


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Dictionary) -> Vector4:
		return Vector4(value.x, value.y, value.z, value.w)
	)

	assert_valid_and_parse_eq({"x": 1, "y": 2, "z": 3, "w": 4}, Vector4(1, 2, 3, 4))


func test_schema():
	var nested_schema := JSONSchema.new()
	nested_schema.add_int("id").set_min(0)
	schema_add_attr().set_schema(nested_schema)

	assert_valid({"id": 0})
	assert_valid({"id": 12345})

	assert_invalid_with_wrong_type_msg({"id": "0"}, "int", ["id"])
	assert_invalid_with_error_msg(
		{"id": -1},
		"int:less_than_min",
		"-1 is less than the minimum allowed (0)",
		{"value": -1, "min": 0},
		["id"]
	)
