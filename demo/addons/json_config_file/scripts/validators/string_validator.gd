extends "./validator.gd"

const _StringValidator := preload("./string_validator.gd")

const _type_name := "string"

var _min_length := 0
var _min_length_enabled := false
var _max_length := 0
var _max_length_enabled := false
var _pattern := RegEx.new()
var _pattern_enabled := false


func set_min(new_min_length: int) -> _StringValidator:
	_min_length = new_min_length
	_min_length_enabled = true

	return self


func set_max(new_max_length: int) -> _StringValidator:
	_max_length = new_max_length
	_max_length_enabled = true

	return self


func set_pattern(new_pattern: String) -> _StringValidator:
	assert(_pattern.compile(new_pattern) == OK)

	_pattern_enabled = true

	return self


func _validate(value: Variant) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_STRING:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	if _min_length_enabled and value.length() < _min_length:
		msgs.append(_shorter_than_min_error(value, _min_length))

	if _max_length_enabled and value.length() > _max_length:
		msgs.append(_longer_than_max_error(value, _max_length))

	if _pattern_enabled and _pattern.search(value) == null:
		msgs.append(_unmatched_pattern_error(value, _pattern.get_pattern()))

	return msgs


func _parse(value: Variant) -> String:
	return value


static func _shorter_than_min_error(value: String, min_length: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":shorter_than_min",
		"'%s's length is shorter than the minimum length allowed (%d)" % [value, min_length],
		{"value": value, "min_length": min_length},
	)


static func _longer_than_max_error(value: String, max_length: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":longer_than_max",
		"'%s's length is longer than the maximum length allowed (%d)" % [value, max_length],
		{"value": value, "max_length": max_length},
	)


static func _unmatched_pattern_error(value: String, pattern: String) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":unmatched_pattern",
		"'%s' does not match the specified pattern: /%s/" % [value, pattern],
		{"value": value, "pattern": pattern},
	)
