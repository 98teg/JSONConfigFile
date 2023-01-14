extends "./validator.gd"

const _Rect2iValidator := preload("./rect2i_validator.gd")

var _min_position := Vector2.ZERO
var _min_position_enabled := false
var _max_position := Vector2.ZERO
var _max_position_enabled := false
var _min_size := Vector2.ZERO
var _min_size_enabled := false
var _max_size := Vector2.ZERO
var _max_size_enabled := false


func set_min_position(new_min_position: Vector2i) -> _Rect2iValidator:
	_min_position = new_min_position
	_min_position_enabled = true

	return self


func set_max_position(new_max_position: Vector2i) -> _Rect2iValidator:
	_max_position = new_max_position
	_max_position_enabled = true

	return self


func set_min_size(new_min_size: Vector2i) -> _Rect2iValidator:
	_min_size = new_min_size
	_min_size_enabled = true

	return self


func set_max_size(new_max_size: Vector2i) -> _Rect2iValidator:
	_max_size = new_max_size
	_max_size_enabled = true

	return self


func _schema() -> JSONSchema:
	var schema := JSONSchema.new()

	var x := schema.add_int("x")
	var y := schema.add_int("y")
	if _min_position_enabled:
		x.set_min(_min_position.x)
		y.set_min(_min_position.y)
	if _max_position_enabled:
		x.set_max(_max_position.x)
		y.set_max(_max_position.y)

	var w := schema.add_int("w")
	var h := schema.add_int("h")
	if _min_size_enabled:
		w.set_min(_min_size.x)
		h.set_min(_min_size.y)
	if _max_size_enabled:
		w.set_max(_max_size.x)
		h.set_max(_max_size.y)

	return schema


func _validate(value: Variant) -> Array[_ValidationMsg]:
	return _schema()._validate(value)


func _parse(value: Variant) -> Rect2i:
	return Rect2i(value.x, value.y, value.w, value.h)
