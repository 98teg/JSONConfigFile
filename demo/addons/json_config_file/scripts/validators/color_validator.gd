extends "./validator.gd"

const _ColorValidator := preload("./color_validator.gd")


func set_custom_parsing(new_custom_parsing: Callable) -> _ColorValidator:
	_custom_parsing = new_custom_parsing

	return self


func _schema() -> JSONSchema:
	var schema := JSONSchema.new()

	schema.add_int("r").set_min(0).set_max(255)
	schema.add_int("g").set_min(0).set_max(255)
	schema.add_int("b").set_min(0).set_max(255)
	schema.add_int("a").set_default_value(255).set_min(0).set_max(255)

	return schema


func _validate(value: Variant) -> Array[_ValidationMsg]:
	return _schema()._validate(value)


func _parse(value: Variant) -> Color:
	var parsed_value = _schema()._parse(value)

	return Color(
		value.r / 255.0,
		value.g / 255.0,
		value.b / 255.0,
		value.a / 255.0
	)
