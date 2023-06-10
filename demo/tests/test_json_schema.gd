extends GutTest

const ValidationMsg := preload("res://addons/json_config_file/scripts/validation_msg.gd")

const properties_folder := "res://addons/json_config_file/scripts/properties/"
const properties_index := {
	"array": preload(properties_folder + "array_property.gd"),
	"bool": preload(properties_folder + "bool_property.gd"),
	"color": preload(properties_folder + "color_property.gd"),
	"dictionary": preload(properties_folder + "dictionary_property.gd"),
	"enum": preload(properties_folder + "enum_property.gd"),
	"file_access": preload(properties_folder + "file_access_property.gd"),
	"float": preload(properties_folder + "float_property.gd"),
	"int": preload(properties_folder + "int_property.gd"),
	"json_config_file": preload(properties_folder + "json_config_file_property.gd"),
	"rect2i": preload(properties_folder + "rect2i_property.gd"),
	"rect2": preload(properties_folder + "rect2_property.gd"),
	"string_name": preload(properties_folder + "string_name_property.gd"),
	"string": preload(properties_folder + "string_property.gd"),
	"vector2i": preload(properties_folder + "vector2i_property.gd"),
	"vector2": preload(properties_folder + "vector2_property.gd"),
	"vector3i": preload(properties_folder + "vector3i_property.gd"),
	"vector3": preload(properties_folder + "vector3_property.gd"),
}

var json_schema: JSONSchema


func before_each():
	json_schema = JSONSchema.new()


func test_default_behaviour():
	assert_valid_and_parse_eq({}, {})

	assert_invalid_with_error_msg(
		{"id": 1},
		"object:not_allowed_property",
		"Unkown property: 'id', this property is not allowed",
		{"property": "id"},
	)


func test_exclusivity():
	json_schema.add_int("a").set_default_value(1)
	json_schema.add_int("b").set_default_value(2)
	json_schema.add_int("c").set_default_value(3)

	json_schema.add_exclusivity(["a", "b", "c"])

	assert_valid_and_parse_eq({}, {"a": 1, "b": 2, "c": 3})
	assert_valid_and_parse_eq({"a": 0}, {"a": 0, "b": 2, "c": 3})
	assert_valid_and_parse_eq({"b": 0}, {"a": 1, "b": 0, "c": 3})
	assert_valid_and_parse_eq({"c": 0}, {"a": 1, "b": 2, "c": 0})

	assert_invalid_with_error_msg(
		{"a": 0, "b": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'a', 'b'",
		{"properties": [&"a", &"b"]},
	)
	assert_invalid_with_error_msg(
		{"b": 0, "c": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'b', 'c'",
		{"properties": [&"b", &"c"]},
	)
	assert_invalid_with_error_msg(
		{"a": 0, "c": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'a', 'c'",
		{"properties": [&"a", &"c"]},
	)
	assert_invalid_with_error_msg(
		{"a": 0, "b": 0, "c": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'a', 'b', 'c'",
		{"properties": [&"a", &"b", &"c"]},
	)


func test_exclusivity_and_one_is_required():
	json_schema.add_int("a").set_default_value(1)
	json_schema.add_int("b").set_default_value(2)
	json_schema.add_int("c").set_default_value(3)

	json_schema.add_exclusivity(["a", "b", "c"], true)

	assert_valid_and_parse_eq({"a": 0}, {"a": 0, "b": 2, "c": 3})
	assert_valid_and_parse_eq({"b": 0}, {"a": 1, "b": 0, "c": 3})
	assert_valid_and_parse_eq({"c": 0}, {"a": 1, "b": 2, "c": 0})

	assert_invalid_with_error_msg(
		{},
		"object:one_property_is_required",
		"One of this properties needs to be specified: 'a', 'b', 'c'",
		{"properties": [&"a", &"b", &"c"]},
	)
	assert_invalid_with_error_msg(
		{"a": 0, "b": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'a', 'b'",
		{"properties": [&"a", &"b"]},
	)
	assert_invalid_with_error_msg(
		{"b": 0, "c": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'b', 'c'",
		{"properties": [&"b", &"c"]},
	)
	assert_invalid_with_error_msg(
		{"a": 0, "c": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'a', 'c'",
		{"properties": [&"a", &"c"]},
	)
	assert_invalid_with_error_msg(
		{"a": 0, "b": 0, "c": 0},
		"object:exclusive_properties",
		"This properties can not be defined at the same time: 'a', 'b', 'c'",
		{"properties": [&"a", &"b", &"c"]},
	)


func test_dependency():
	json_schema.add_int("a").set_default_value(1)
	json_schema.add_int("b").set_default_value(2)

	json_schema.add_dependency("a", "b")

	assert_valid_and_parse_eq({}, {"a": 1, "b": 2})
	assert_valid_and_parse_eq({"b": 0}, {"a": 1, "b": 0})
	assert_valid_and_parse_eq({"a": 0, "b": 0}, {"a": 0, "b": 0})

	assert_invalid_with_error_msg(
		{"a": 0},
		"object:required_dependent_property",
		"Missing property: 'b', this property is required if 'a' has been specified",
		{"main_property": &'a', "dependent_property": &'b'},
	)


func test_add_x_methods():
	for property in properties_index.keys():
		var method_name = "add_%s" % property
		var property_class = properties_index[property]
		var property_name = "%s_property" % property

		assert_has_method(json_schema, method_name)
		assert_is(json_schema.call(method_name, property_name), property_class)
		assert_true(json_schema._property_exists(property_name))
		assert_is(json_schema._properties[-1], property_class)


func assert_valid_and_parse_eq(value: Dictionary, expected_value: Dictionary):
	assert_eq(json_schema._validate(value), [])
	assert_eq(json_schema._parse(value), expected_value)


func assert_invalid_with_error_msg(
	value: Dictionary,
	code: String,
	message: String,
	info: Dictionary,
	context_sub_levels := [],
):
	assert_ne(json_schema._validate(value), [])

	var msgs: Array[ValidationMsg] = json_schema._validate(value)
	assert_eq(msgs.size(), 1)

	if msgs.size() != 1:
		return

	var msg = msgs[0]
	assert_eq(msg.importance, ValidationMsg.Importance.ERROR)
	assert_eq(msg.code, code)
	assert_eq_deep(msg.context_levels, context_sub_levels)
	assert_eq(msg.message, message)
	assert_eq_deep(msg.info, info)
