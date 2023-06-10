extends "./validator.gd"

const _Vector3iValidator := preload("./vector3i_validator.gd")

var _min := Vector3i.ZERO
var _min_enabled := false
var _max := Vector3i.ZERO
var _max_enabled := false


func set_custom_parsing(new_custom_parsing: Callable) -> _Vector3iValidator:
	_custom_parsing = new_custom_parsing

	return self


func set_min(new_min: Vector3i) -> _Vector3iValidator:
	_min = new_min
	_min_enabled = true

	return self


func set_max(new_max: Vector3i) -> _Vector3iValidator:
	_max = new_max
	_max_enabled = true

	return self


func _schema() -> JSONSchema:
	var schema := JSONSchema.new()

	var x := schema.add_int("x")
	var y := schema.add_int("y")
	var z := schema.add_int("z")
	if _min_enabled:
		x.set_min(_min.x)
		y.set_min(_min.y)
		z.set_min(_min.z)
	if _max_enabled:
		x.set_max(_max.x)
		y.set_max(_max.y)
		z.set_max(_max.z)

	return schema


func _validate(value: Variant) -> Array[_ValidationMsg]:
	return _schema()._validate(value)


func _parse(value: Variant) -> Vector3i:
	return Vector3i(value.x, value.y, value.z)
