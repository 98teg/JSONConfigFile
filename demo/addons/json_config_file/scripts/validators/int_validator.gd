extends "./validator.gd"

const _IntValidator := preload("./int_validator.gd")

const _type_name := "int"

var _min := 0
var _min_enabled := false
var _max := 0
var _max_enabled := false


func set_custom_parsing(new_custom_parsing: Callable) -> _IntValidator:
	_custom_parsing = new_custom_parsing

	return self


func set_min(new_min: int) -> _IntValidator:
	_min = new_min
	_min_enabled = true

	return self


func set_max(new_max: int) -> _IntValidator:
	_max = new_max
	_max_enabled = true

	return self


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	if absf(value - int(value)) != 0:
		msgs.append(_ValidationMsg._wrong_type_error(_type_name))

	if _min_enabled and value < _min:
		msgs.append(_less_than_min_error(value, _min))

	if _max_enabled and value > _max:
		msgs.append(_more_than_max_error(value, _max))

	return msgs


func _parse(value: Variant) -> int:
	return value


static func _less_than_min_error(value: int, min: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":less_than_min",
		"%d is less than the minimum allowed (%d)" % [value, min],
		{"value": value, "min": min},
	)


static func _more_than_max_error(value: int, max: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":more_than_max",
		"%d is more than the maximum allowed (%d)" % [value, max],
		{"value": value, "max": max},
	)
