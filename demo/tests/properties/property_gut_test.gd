extends GutTest
class_name PropertyGutTest

const ValidationMsg := preload("res://addons/json_config_file/scripts/validation_msg.gd")

const validators_folder := "res://addons/json_config_file/scripts/validators/"
const validators_index := {
	"array": preload(validators_folder + "array_validator.gd"),
	"bool": preload(validators_folder + "bool_validator.gd"),
	"color": preload(validators_folder + "color_validator.gd"),
	"dictionary": preload(validators_folder + "dictionary_validator.gd"),
	"enum": preload(validators_folder + "enum_validator.gd"),
	"file_access": preload(validators_folder + "file_access_validator.gd"),
	"float": preload(validators_folder + "float_validator.gd"),
	"int": preload(validators_folder + "int_validator.gd"),
	"json_config_file": preload(validators_folder + "json_config_file_validator.gd"),
	"rect2i": preload(validators_folder + "rect2i_validator.gd"),
	"rect2": preload(validators_folder + "rect2_validator.gd"),
	"string_name": preload(validators_folder + "string_name_validator.gd"),
	"string": preload(validators_folder + "string_validator.gd"),
	"vector2i": preload(validators_folder + "vector2i_validator.gd"),
	"vector2": preload(validators_folder + "vector2_validator.gd"),
	"vector3i": preload(validators_folder + "vector3i_validator.gd"),
	"vector3": preload(validators_folder + "vector3_validator.gd"),
}
const attr_key := "attr"

var json_config_file_path := ""
var schema: JSONSchema


func set_json_config_file_path(new_json_config_file_path: String) -> void:
	json_config_file_path = new_json_config_file_path


func valid(value: Variant) -> bool:
	return schema._validate({attr_key: value}, json_config_file_path) == []


func validate(value: Variant) -> Array[ValidationMsg]:
	return schema._validate({attr_key: value}, json_config_file_path)


func parse(value: Variant) -> Variant:
	return schema._parse({attr_key: value}, json_config_file_path)[attr_key]


func assert_valid(value: Variant):
	assert_true(valid(value))


func assert_invalid(value: Variant):
	assert_false(valid(value))


func assert_parse_eq(value: Variant, expected_value: Variant):
	assert_eq(parse(value), expected_value)


func assert_valid_and_parse_eq(value: Variant, expected_value: Variant):
	assert_valid(value)

	if valid(value):
		assert_parse_eq(value, expected_value)


func assert_has_default_value(expected_value: Variant):
	assert_eq(schema._parse({}, json_config_file_path)[attr_key], expected_value)


func assert_invalid_with_wrong_type_msg(value: Variant, type: String, context_sub_levels := []):
	assert_invalid_with_error_msg(
		value,
		"wrong_type",
		"Wrong type: expected '%s'" % type,
		{"type": type},
		context_sub_levels,
	)


func assert_invalid_with_error_msg(
	value: Variant,
	code: String,
	message: String,
	info: Dictionary,
	context_sub_levels := [],
):
	assert_invalid(value)

	if valid(value):
		return

	var msgs: Array[ValidationMsg] = validate(value)
	assert_eq(msgs.size(), 1)

	if msgs.size() != 1:
		return

	var msg = msgs[0]
	assert_eq(msg.importance, ValidationMsg.Importance.ERROR)
	assert_eq(msg.code, code)
	assert_eq_deep(msg.context_levels, [attr_key] + context_sub_levels)
	assert_eq(msg.message, message)
	assert_eq_deep(msg.info, info)


func before_each():
	schema = JSONSchema.new()
