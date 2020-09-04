class_name JSONPropertyImage
extends JSONProperty


func _validate_type(image) -> void:
	if image is Image:
		_result = image
	elif typeof(image) == TYPE_STRING:
		var image_path

		if image.is_abs_path():
			image_path = image
		else:
			image_path = _dir_path.plus_file(image)

		var result = Image.new()
		if File.new().file_exists(image_path):
			var error = result.load(image_path)
			if error != OK:
				_errors.append({
					"error": JSONProperty.Errors.COULD_NOT_OPEN_IMAGE,
					"code": error,
				})
			else:
				_result = result
		else:
			_errors.append({
				"error": JSONProperty.Errors.COULD_NOT_OPEN_IMAGE,
				"code": ERR_FILE_NOT_FOUND,
			})
	else:
		_errors.append({
			"error": Errors.WRONG_TYPE,
			"expected": Types.IMAGE,
		})
