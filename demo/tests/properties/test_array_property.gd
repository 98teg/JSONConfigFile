extends PropertyGutTest


func schema_add_attr():
	return schema.add_array(attr_key)


func test_default_property():
	schema_add_attr()

	assert_valid_and_parse_eq([], [])
	assert_valid_and_parse_eq([1, 2, 3, 4, 5], [1, 2, 3, 4, 5])
	assert_valid_and_parse_eq(["1", 2, "3", 4, "5"], ["1", 2, "3", 4, "5"])

	assert_invalid_with_wrong_type_msg("1,2,3", "array")


func test_default_value():
	schema_add_attr().set_default_value([1, 2, 3])

	assert_has_default_value([1, 2, 3])


func test_custom_parsing():
	schema_add_attr().set_custom_parsing(func(value: Array) -> Array:
		return value.map(func(number: int) -> int:
			return number * 2
		)
	)

	assert_valid_and_parse_eq([1, 2, 3], [2, 4, 6])


func test_min_size():
	schema_add_attr().set_min_size(1)

	assert_valid([1])
	assert_valid([1, 2, 3, 4, 5])

	assert_invalid_with_error_msg(
		[],
		"array:shorter_than_min",
		"Array's size (0) is shorter than the minimum size allowed (1)",
		{"size": 0, "min_size": 1},
	)


func test_max_size():
	schema_add_attr().set_max_size(3)

	assert_valid([])
	assert_valid([1])

	assert_invalid_with_error_msg(
		[1, 2, 3, 4, 5],
		"array:longer_than_max",
		"Array's size (5) is longer than the maximum size allowed (3)",
		{"size": 5, "max_size": 3},
	)


func test_enable_uniqueness():
	schema_add_attr().enable_uniqueness()

	assert_valid([1, 2, 3])
	assert_valid([1, "1", 2])

	assert_invalid_with_error_msg(
		[2, 1, 3, 1.0, 5],
		"array:two_elements_are_equal",
		"Array contains two elements that are equal, [1] and [3]",
		{"i": 1, "j": 3},
	)
	assert_invalid_with_error_msg(
		["1", "1", 3, 4, 5],
		"array:two_elements_are_equal",
		"Array contains two elements that are equal, [0] and [1]",
		{"i": 0, "j": 1},
	)


func test_enable_custom_uniqueness():
	schema_add_attr().enable_uniqueness(
		func(objA, objB) -> bool:
			if (typeof(objA) != TYPE_DICTIONARY or typeof(objB) != TYPE_DICTIONARY):
				return false

			if (not objA.has("id") or not objB.has("id")):
				return false

			return objA["id"] == objB["id"]
	)

	assert_valid([{"id": 1}, {"id": 2}, {"id": 3}])
	assert_valid([1, {"id": 1}, 1])

	assert_invalid_with_error_msg(
		[{"id": 1}, {"id": 2}, {"id": 1}],
		"array:two_elements_are_equal",
		"Array contains two elements that are equal, [0] and [2]",
		{"i": 0, "j": 2},
	)


func test_with_int_elements():
	schema_add_attr().with_int_elements().set_min(-10).set_max(10)

	assert_valid_and_parse_eq([], [])
	assert_valid_and_parse_eq([1, 2, 3], [1, 2, 3])
	assert_valid_and_parse_eq([-1, 5, -2, 0.0, -1], [-1, 5, -2, 0, -1])

	assert_invalid_with_wrong_type_msg([0.5, 2, 3], "int", [0])
	assert_invalid_with_wrong_type_msg([1, 0.5, 3], "int", [1])
	assert_invalid_with_wrong_type_msg([1, 2, 0.5], "int", [2])

	assert_invalid_with_error_msg(
		[-11, 2, 3],
		"int:less_than_min",
		"-11 is less than the minimum allowed (-10)",
		{"value": -11, "min": -10},
		[0]
	)
	assert_invalid_with_error_msg(
		[1, 2, 33],
		"int:more_than_max",
		"33 is more than the maximum allowed (10)",
		{"value": 33, "max": 10},
		[2]
	)


func test_with_x_elements_methods():
	var array_validator = schema_add_attr()

	for validator in validators_index.keys():
		var method_name = "with_%s_elements" % validator
		var validator_class = validators_index[validator]

		assert_has_method(array_validator, method_name)
		assert_is(array_validator.call(method_name), validator_class)
		assert_true(array_validator._validator._validator_enabled)
		assert_is(array_validator._validator._validator, validator_class)
