extends "./validator.gd"


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
		parsed_value.r / 255.0,
		parsed_value.g / 255.0,
		parsed_value.b / 255.0,
		parsed_value.a / 255.0
	)
