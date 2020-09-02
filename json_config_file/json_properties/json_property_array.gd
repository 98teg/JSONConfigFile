class_name JSONPropertyArray
extends JSONProperty


var _min_size = null
var _max_size = null
var _element_property := JSONProperty.new()
var _uniqueness := false


func set_min_size(min_size : int) -> void:
	_min_size = min_size


func remove_min_size() -> void:
	_min_size = null


func set_max_size(max_size : int) -> void:
	_max_size = max_size


func remove_max_size() -> void:
	_max_size = null


func set_element_property(element_property : JSONProperty) -> void:
	_element_property = element_property


func remove_element_property() -> void:
	_max_size = JSONProperty.new()


func set_uniqueness(uniqueness : bool) -> void:
	_uniqueness = uniqueness


func _validate_type(array) -> void:
	if typeof(array) == TYPE_ARRAY:
		if _min_size != null and array.size() < _min_size:
			_errors.append({
				"error": Errors.ARRAY_SMALLER_THAN_MIN,
				"min": _min_size,
				"size": array.size(),
			})
		elif _max_size != null and array.size() > _max_size:
			_errors.append({
				"error": Errors.ARRAY_BIGGER_THAN_MAX,
				"max": _max_size,
				"size": array.size(),
			})
		else :
			_result = []

			_element_property._set_dir_path(_dir_path)
			for i in range(array.size()):
				_element_property.validate(array[i])

				_result.append(_element_property.get_result())

				for error in _element_property.get_errors():
					var index = "[" + String(i) + "]"
					
					if error.has("context"):
						error.context = index + "/" + error.context
					else:
						error.context = index

					_errors.append(error)

			if _uniqueness and not has_errors():
				for i in range(0, get_result().size()):
					for j in range(1 + i, get_result().size()):
						var value_1 = get_result()[i]
						var value_2 = get_result()[j]

						if Comparator.are_equal(value_1, value_2):
							_errors.append({
								"error": Errors.ARRAY_TWO_ELEMENTS_ARE_EQUAL,
								"element_1": i,
								"element_2": j,
							})
	else:
		_errors.append({
			"error": Errors.WRONG_TYPE,
			"expected": Types.ARRAY,
		})
