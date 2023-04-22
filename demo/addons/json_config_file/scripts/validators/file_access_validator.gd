extends "./validator.gd"

enum _OpenMode {
	NORMAL,
	COMPRESSED,
	ENCRYPTED,
	ENCRYPTED_WITH_PASS,
}

const _FileAccessValidator := preload("./file_access_validator.gd")

const _type_name := "file_path"
const _errors_index := {
	OK: "OK",
	FAILED: "FAILED",
	ERR_UNAVAILABLE: "ERR_UNAVAILABLE",
	ERR_UNCONFIGURED: "ERR_UNCONFIGURED",
	ERR_UNAUTHORIZED: "ERR_UNAUTHORIZED",
	ERR_PARAMETER_RANGE_ERROR: "ERR_PARAMETER_RANGE_ERROR",
	ERR_OUT_OF_MEMORY: "ERR_OUT_OF_MEMORY",
	ERR_FILE_NOT_FOUND: "ERR_FILE_NOT_FOUND",
	ERR_FILE_BAD_DRIVE: "ERR_FILE_BAD_DRIVE",
	ERR_FILE_BAD_PATH: "ERR_FILE_BAD_PATH",
	ERR_FILE_NO_PERMISSION: "ERR_FILE_NO_PERMISSION",
	ERR_FILE_ALREADY_IN_USE: "ERR_FILE_ALREADY_IN_USE",
	ERR_FILE_CANT_OPEN: "ERR_FILE_CANT_OPEN",
	ERR_FILE_CANT_WRITE: "ERR_FILE_CANT_WRITE",
	ERR_FILE_CANT_READ: "ERR_FILE_CANT_READ",
	ERR_FILE_UNRECOGNIZED: "ERR_FILE_UNRECOGNIZED",
	ERR_FILE_CORRUPT: "ERR_FILE_CORRUPT",
	ERR_FILE_MISSING_DEPENDENCIES: "ERR_FILE_MISSING_DEPENDENCIES",
	ERR_FILE_EOF: "ERR_FILE_EOF",
	ERR_CANT_OPEN: "ERR_CANT_OPEN",
	ERR_CANT_CREATE: "ERR_CANT_CREATE",
	ERR_QUERY_FAILED: "ERR_QUERY_FAILED",
	ERR_ALREADY_IN_USE: "ERR_ALREADY_IN_USE",
	ERR_LOCKED: "ERR_LOCKED",
	ERR_TIMEOUT: "ERR_TIMEOUT",
	ERR_CANT_CONNECT: "ERR_CANT_CONNECT",
	ERR_CANT_RESOLVE: "ERR_CANT_RESOLVE",
	ERR_CONNECTION_ERROR: "ERR_CONNECTION_ERROR",
	ERR_CANT_ACQUIRE_RESOURCE: "ERR_CANT_ACQUIRE_RESOURCE",
	ERR_CANT_FORK: "ERR_CANT_FORK",
	ERR_INVALID_DATA: "ERR_INVALID_DATA",
	ERR_INVALID_PARAMETER: "ERR_INVALID_PARAMETER",
	ERR_ALREADY_EXISTS: "ERR_ALREADY_EXISTS",
	ERR_DOES_NOT_EXIST: "ERR_DOES_NOT_EXIST",
	ERR_DATABASE_CANT_READ: "ERR_DATABASE_CANT_READ",
	ERR_DATABASE_CANT_WRITE: "ERR_DATABASE_CANT_WRITE",
	ERR_COMPILATION_FAILED: "ERR_COMPILATION_FAILED",
	ERR_METHOD_NOT_FOUND: "ERR_METHOD_NOT_FOUND",
	ERR_LINK_FAILED: "ERR_LINK_FAILED",
	ERR_SCRIPT_FAILED: "ERR_SCRIPT_FAILED",
	ERR_CYCLIC_LINK: "ERR_CYCLIC_LINK",
	ERR_INVALID_DECLARATION: "ERR_INVALID_DECLARATION",
	ERR_DUPLICATE_SYMBOL: "ERR_DUPLICATE_SYMBOL",
	ERR_PARSE_ERROR: "ERR_PARSE_ERROR",
	ERR_BUSY: "ERR_BUSY",
	ERR_SKIP: "ERR_SKIP",
	ERR_HELP: "ERR_HELP",
	ERR_BUG: "ERR_BUG",
	ERR_PRINTER_ON_FIRE: "ERR_PRINTER_ON_FIRE",
}

var _open_mode := _OpenMode.NORMAL
var _mode_flags := FileAccess.READ
var _compression_mode := FileAccess.COMPRESSION_FASTLZ
var _key: PackedByteArray = []
var _password := ""


func _init():
	_requires_json_config_file_path = true


func set_open(new_mode_flags := FileAccess.READ) -> _FileAccessValidator:
	assert(_valid_mode_flags(new_mode_flags))

	_open_mode = _OpenMode.NORMAL
	_mode_flags = new_mode_flags

	return self


func set_open_compressed(
	new_compression_mode: int, new_mode_flags := FileAccess.READ
) -> _FileAccessValidator:
	assert(_valid_compression_mode(new_compression_mode))
	assert(_valid_mode_flags(new_mode_flags))

	_open_mode = _OpenMode.COMPRESSED
	_compression_mode = new_compression_mode
	_mode_flags = new_mode_flags

	return self


func set_open_encrypted(
	new_key: PackedByteArray, new_mode_flags := FileAccess.READ
) -> _FileAccessValidator:
	assert(_valid_mode_flags(new_mode_flags))

	_open_mode = _OpenMode.ENCRYPTED
	_key = new_key
	_mode_flags = new_mode_flags

	return self


func set_open_encrypted_with_pass(
	new_password: String, new_mode_flags := FileAccess.READ
) -> _FileAccessValidator:
	assert(_valid_mode_flags(new_mode_flags))

	_open_mode = _OpenMode.ENCRYPTED_WITH_PASS
	_password = new_password
	_mode_flags = new_mode_flags

	return self


func _valid_mode_flags(mode_flags: int) -> bool:
	return [FileAccess.READ, FileAccess.WRITE, FileAccess.READ_WRITE, FileAccess.WRITE_READ].has(
		mode_flags
	)


func _valid_compression_mode(compression_mode: int) -> bool:
	return [
		FileAccess.COMPRESSION_FASTLZ,
		FileAccess.COMPRESSION_DEFLATE,
		FileAccess.COMPRESSION_ZSTD,
		FileAccess.COMPRESSION_GZIP
	].has(compression_mode)


func _validate(value: Variant, json_config_file_path: String) -> Array[_ValidationMsg]:
	if typeof(value) != TYPE_STRING:
		return [_ValidationMsg._wrong_type_error(_type_name)]

	var msgs: Array[_ValidationMsg] = []

	var path := _path(value, json_config_file_path)
	var file := _parse(path, json_config_file_path)

	if !file:
		msgs.append(_could_not_open_file(path, FileAccess.get_open_error()))

	return msgs


func _parse(value: Variant, json_config_file_path: String) -> FileAccess:
	var path = _path(value, json_config_file_path)

	match _open_mode:
		_OpenMode.COMPRESSED:
			return FileAccess.open_compressed(path, _mode_flags, _compression_mode)
		_OpenMode.ENCRYPTED:
			return FileAccess.open_encrypted(path, _mode_flags, _key)
		_OpenMode.ENCRYPTED_WITH_PASS:
			return FileAccess.open_encrypted_with_pass(path, _mode_flags, _password)
		_:
			return FileAccess.open(path, _mode_flags)


static func _could_not_open_file(path: String, code: int) -> _ValidationMsg:
	return _ValidationMsg.new_error(
		_type_name + ":could_not_open_file",
		"Could not open file at: %s [%s]" % [path, _errors_index[code]],
		{"path": path, "code": code, "code_as_string": _errors_index[code]}
	)


static func _path(value: Variant, json_config_file_path: String) -> String:
	var dir := json_config_file_path.get_base_dir()
	var path := dir.path_join(value) if value.is_relative_path() else value

	return ProjectSettings.globalize_path(path).simplify_path()
