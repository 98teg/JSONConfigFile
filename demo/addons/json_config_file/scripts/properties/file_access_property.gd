extends "./property.gd"

const _FileAccessValidator := preload("../validators/file_access_validator.gd")
const _FileAccessProperty := preload("./file_access_property.gd")

var _validator := _FileAccessValidator.new()
var _default_value = null


func set_required(new_required: bool) -> _FileAccessProperty:
	_required = new_required

	return self


func set_default_value(new_default_value: FileAccess) -> _FileAccessProperty:
	set_required(false)
	_default_value = new_default_value

	return self


func set_custom_parsing(new_custom_parsing: Callable) -> _FileAccessProperty:
	_validator.set_custom_parsing(new_custom_parsing)

	return self


func set_open(new_mode_flags := FileAccess.READ) -> _FileAccessProperty:
	_validator.set_open(new_mode_flags)

	return self


func set_open_compressed(
	new_compression_mode: int, new_mode_flags := FileAccess.READ
) -> _FileAccessProperty:
	_validator.set_open_compressed(new_compression_mode, new_mode_flags)

	return self


func set_open_encrypted(
	new_key: PackedByteArray, new_mode_flags := FileAccess.READ
) -> _FileAccessProperty:
	_validator.set_open_encrypted(new_key, new_mode_flags)

	return self


func set_open_encrypted_with_pass(
	new_password: String, new_mode_flags := FileAccess.READ
) -> _FileAccessProperty:
	_validator.set_open_encrypted_with_pass(new_password, new_mode_flags)

	return self
