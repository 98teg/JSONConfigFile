extends "./validator.gd"

const _ArrayValidator := preload("./array_validator.gd")
const _BoolValidator := preload("./bool_validator.gd")
const _ColorValidator := preload("./color_validator.gd")
const _DictionaryValidator := preload("./dictionary_validator.gd")
const _EnumValidator := preload("./enum_validator.gd")
const _FileAccessValidator := preload("./file_access_validator.gd")
const _FloatValidator := preload("./float_validator.gd")
const _IntValidator := preload("./int_validator.gd")
const _JSONConfigFileValidator := preload("./json_config_file_validator.gd")
const _Rect2iValidator := preload("./rect2i_validator.gd")
const _Rect2Validator := preload("./rect2_validator.gd")
const _StringNameValidator := preload("./string_name_validator.gd")
const _StringValidator := preload("./string_validator.gd")
const _Vector2iValidator := preload("./vector2i_validator.gd")
const _Vector2Validator := preload("./vector2_validator.gd")
const _Vector3iValidator := preload("./vector3i_validator.gd")
const _Vector3Validator := preload("./vector3_validator.gd")

const _type_name := "array"

var _min_size := 0
var _min_size_enabled := false
var _max_size := 0
var _max_size_enabled := false
var _uniqueness_enabled := false
var _are_equal: Callable
var _validator: Object
var _validator_enabled := false


func set_min_size(new_min_size: int) -> _ArrayValidator:
	_min_size = new_min_size
	_min_size_enabled = true

	return self


func set_max_size(new_max_size: int) -> _ArrayValidator:
	_max_size = new_max_size
	_max_size_enabled = true

	return self


func enable_uniqueness(new_are_equal := func(a, b) -> bool:
	var is_a_numeric = [TYPE_INT, TYPE_FLOAT].has(typeof(a))
	var is_b_numeric = [TYPE_INT, TYPE_FLOAT].has(typeof(b))

	return ((is_a_numeric and is_b_numeric) or typeof(a) == typeof(b)) and a == b
) -> _ArrayValidator:
	_uniqueness_enabled = true
	_are_equal = new_are_equal

	return self


func with_array_elements() -> _ArrayValidator:
	return _set_validator(_ArrayValidator)


func with_bool_elements() -> _BoolValidator:
	return _set_validator(_BoolValidator)


func with_color_elements() -> _ColorValidator:
	return _set_validator(_ColorValidator)


func with_dictionary_elements() -> _DictionaryValidator:
	return _set_validator(_DictionaryValidator)


func with_enum_elements() -> _EnumValidator:
	return _set_validator(_EnumValidator)


func with_file_access_elements() -> _FileAccessValidator:
	return _set_validator(_FileAccessValidator)


func with_float_elements() -> _FloatValidator:
	return _set_validator(_FloatValidator)


func with_int_elements() -> _IntValidator:
	return _set_validator(_IntValidator)


func with_json_config_file_elements() -> _JSONConfigFileValidator:
	return _set_validator(_JSONConfigFileValidator)


func with_rect2i_elements() -> _Rect2iValidator:
	return _set_validator(_Rect2iValidator)


func with_rect2_elements() -> _Rect2Validator:
	return _set_validator(_Rect2Validator)


func with_string_name_elements() -> _StringNameValidator:
	return _set_validator(_StringNameValidator)


func with_string_elements() -> _StringValidator:
	return _set_validator(_StringValidator)


func with_vector2i_elements() -> _Vector2iValidator:
	return _set_validator(_Vector2iValidator)


func with_vector2_elements() -> _Vector2Validator:
	return _set_validator(_Vector2Validator)


func with_vector3i_elements() -> _Vector3iValidator:
	return _set_validator(_Vector3iValidator)


func with_vector3_elements() -> _Vector3Validator:
	return _set_validator(_Vector3Validator)


func _set_validator(validator_script: Script) -> Object:
	_validator = validator_script.new()
	_validator_enabled = true

	return _validator


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_ARRAY:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	if _min_size_enabled and value.size() < _min_size:
		msgs.append(_shorter_than_min_error(value.size(), _min_size))

	if _max_size_enabled and value.size() > _max_size:
		msgs.append(_longer_than_max_error(value.size(), _max_size))

	if _validator_enabled:
		var i := 0
		for element in value:
			var element_msgs: Array = _validator._validate(element)

			for msg in element_msgs:
				msg._add_context_level(i)
				msgs.append(msg)

			i += 1

	if _uniqueness_enabled:
		for i in range(value.size()):
			for j in range(i, value.size()):
				if i != j and _are_equal.call(value[i], value[j]):
					msgs.append(_two_elements_are_equal_error(i, j))

	return msgs


func _parse(value: Variant) -> Array:
	if _validator_enabled:
		return value.map(func (element): return _validator._parse(element))

	return value


static func _shorter_than_min_error(size: int, min_size: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":shorter_than_min",
		"Array's size (%d) is shorter than the minimum size allowed (%d)" % [size, min_size],
		{"size": size, "min_size": min_size},
	)


static func _longer_than_max_error(size: int, max_size: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":longer_than_max",
		"Array's size (%d) is longer than the maximum size allowed (%d)" % [size, max_size],
		{"size": size, "max_size": max_size},
	)


static func _two_elements_are_equal_error(i: int, j: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":two_elements_are_equal",
		"Array contains two elements that are equal, [%d] and [%d]" % [i, j],
		{"i": i, "j": j},
	)
