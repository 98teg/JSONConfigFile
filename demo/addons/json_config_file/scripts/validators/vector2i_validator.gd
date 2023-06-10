extends "./validator.gd"

const _Vector2iValidator := preload("./vector2i_validator.gd")

var _min := Vector2i.ZERO
var _min_enabled := false
var _max := Vector2i.ZERO
var _max_enabled := false


func set_custom_parsing(new_custom_parsing: Callable) -> _Vector2iValidator:
	_custom_parsing = new_custom_parsing

	return self


func set_min(new_min: Vector2i) -> _Vector2iValidator:
	_min = new_min
	_min_enabled = true

	return self


func set_max(new_max: Vector2i) -> _Vector2iValidator:
	_max = new_max
	_max_enabled = true

	return self


func _schema() -> JSONSchema:
	var schema := JSONSchema.new()

	var x := schema.add_int("x")
	var y := schema.add_int("y")
	if _min_enabled:
		x.set_min(_min.x)
		y.set_min(_min.y)
	if _max_enabled:
		x.set_max(_max.x)
		y.set_max(_max.y)

	return schema


func _validate(value: Variant) -> Array[_ValidationMsg]:
	return _schema()._validate(value)


func _parse(value: Variant) -> Vector2i:
	return Vector2i(value.x, value.y)
