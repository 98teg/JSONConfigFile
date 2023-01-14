extends "./validator.gd"

const _FloatValidator := preload("./float_validator.gd")

const _type_name := "float"

var _min := 0.0
var _min_enabled := false
var _max := 0.0
var _max_enabled := false


func set_min(new_min: float) -> _FloatValidator:
	_min = new_min
	_min_enabled = true

	return self


func set_max(new_max: float) -> _FloatValidator:
	_max = new_max
	_max_enabled = true

	return self


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	if _min_enabled and value < _min:
		msgs.append(_less_than_min_error(value, _min))

	if _max_enabled and value > _max:
		msgs.append(_more_than_max_error(value, _max))

	return msgs


func _parse(value: Variant) -> float:
	return value


static func _less_than_min_error(value: float, min: float) -> _ValidationMsg:
	return (
		_ValidationMsg
		. new_error(
			_type_name + ":less_than_min",
			"%s is less than the minimum allowed (%s)" % [value, min],
			{"value": value, "min": min},
		)
	)


static func _more_than_max_error(value: float, max: float) -> _ValidationMsg:
	return (
		_ValidationMsg
		. new_error(
			_type_name + ":more_than_max",
			"%s is more than the maximum allowed (%s)" % [value, max],
			{"value": value, "max": max},
		)
	)
