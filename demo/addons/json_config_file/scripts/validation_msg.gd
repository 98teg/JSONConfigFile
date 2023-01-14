extends Object

enum Importance {
	ERROR,
	WARNING,
}

const ValidationMsg := preload("./validation_msg.gd")

var importance := Importance.ERROR
var code: StringName = ""
var context_levels := []
var message := ""
var info := {}


func _init(
	new_importance: Importance, new_code: StringName, new_message: String, new_info: Dictionary
) -> void:
	importance = new_importance
	code = new_code
	message = new_message
	info = new_info


static func new_error(code: StringName, message: String, info: Dictionary) -> ValidationMsg:
	return ValidationMsg.new(Importance.ERROR, code, message, info)


static func new_warning(code: StringName, message: String, info: Dictionary) -> ValidationMsg:
	return ValidationMsg.new(Importance.WARNING, code, message, info)


func as_text() -> String:
	if context_levels.is_empty():
		return message + "."
	else:
		return message + ", at '" + _context_as_text() + "'."


func _context_as_text() -> String:
	var text := ""

	for level in context_levels:
		match typeof(level):
			TYPE_INT:
				text += "[" + level + "]"
			TYPE_STRING, TYPE_STRING_NAME:
				if text.is_empty():
					text = level
				else:
					text += "." + level
			_:
				assert(false)

	return text


func _add_context_level(level: Variant) -> void:
	context_levels.insert(0, level)


func _to_string() -> String:
	return as_text()


static func _wrong_type_error(type: String) -> ValidationMsg:
	return (
		ValidationMsg
		. new(
			Importance.ERROR,
			"wrong_type",
			"Wrong type: expected '%s'" % type,
			{"type": type},
		)
	)


static func _array_as_text(array: Array) -> String:
	var array_as_text = ""

	for i in range(array.size()):
		array_as_text += "'%s'" % array[i]
		array_as_text += ", " if i != array.size() - 1 else ""

	return array_as_text
