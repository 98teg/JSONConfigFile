extends "./validator.gd"

const _Vector2Validator := preload("./vector2_validator.gd")

var _min := Vector2.ZERO
var _min_enabled := false
var _max := Vector2.ZERO
var _max_enabled := false


func set_custom_parsing(new_custom_parsing: Callable) -> _Vector2Validator:
	_custom_parsing = new_custom_parsing

	return self


func set_min(new_min: Vector2) -> _Vector2Validator:
	_min = new_min
	_min_enabled = true

	return self


func set_max(new_max: Vector2) -> _Vector2Validator:
	_max = new_max
	_max_enabled = true

	return self


func _schema() -> JSONSchema:
	var schema := JSONSchema.new()

	var x := schema.add_float("x")
	var y := schema.add_float("y")
	if _min_enabled:
		x.set_min(_min.x)
		y.set_min(_min.y)
	if _max_enabled:
		x.set_max(_max.x)
		y.set_max(_max.y)

	return schema


func _validate(value: Variant) -> Array[_ValidationMsg]:
	return _schema()._validate(value)


func _parse(value: Variant) -> Vector2:
	return Vector2(value.x, value.y)
