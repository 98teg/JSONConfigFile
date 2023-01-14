extends "./validator.gd"

const _Vector3Validator := preload("./vector3_validator.gd")

var _min := Vector3.ZERO
var _min_enabled := false
var _max := Vector3.ZERO
var _max_enabled := false


func set_min(new_min: Vector3) -> _Vector3Validator:
	_min = new_min
	_min_enabled = true

	return self


func set_max(new_max: Vector3) -> _Vector3Validator:
	_max = new_max
	_max_enabled = true

	return self


func _schema() -> JSONSchema:
	var schema := JSONSchema.new()

	var x := schema.add_float("x")
	var y := schema.add_float("y")
	var z := schema.add_float("z")
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


func _parse(value: Variant) -> Vector3:
	return Vector3(value.x, value.y, value.z)
