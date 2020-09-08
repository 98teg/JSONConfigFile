# JSONConfigFile
## Description
```GDScript
func validate_json_file(json_file : String) -> JSONConfigFile:
	# Create a JSON configuration file
	var json_config_file = JSONConfigFile.new()

	# Add a 'name' property, which is a string
	json_config_file.add_property("name", JSONPropertyString.new())
	# Add an 'age' property, which is an integer
	json_config_file.add_property("age", JSONPropertyInteger.new())

	# Validate input
	json_config_file.validate(json_file)

	# Returns the JSON configuration file
	return json_config_file
```
Input
```JSON
{
    "name": "Mr. Example Person",
    "age": 42
}
```
Output
```
{age:42, name:Mr. Example Person}
```
Errors
```
[]
```
Warnings
```
[]
```

## Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **add_property** | **name -> String:** <br> Name of the property. <br> **property -> JSONProperty:** <br> Object with the conditions of the property. <br> **required -> bool (true):** <br> Determines if the property is obligatory. <br> **default_value -> Variant (null):** <br> If the property is not present or if it does not meet the conditions, this is the value the result would have. | Adds a new property to the JSON configuration file. | Nothing. |
| **add_exclusivity** | **exclusive_properties -> Array:** <br> Array with the names of the exclusive properties. <br> **one_is_required -> bool (false):** <br> Determines if one of the exclusive properties must be present. | Two properties of the array of exclusive properties cannot be present simultaniously. <br><br> **WARNING**: The exclusive properties array cannot contain properties not yet defined or any required property. | **bool:** <br> If the exclusive properties have been succesfully added. |
| **add_dependency** | **main_property -> String:** <br> Name of the main property. <br> **dependent_property -> String:** <br> Name of the dependent property. | If the main property is present, the dependent property must be present too. <br><br> **WARNING**: Neither the main nor the dependent property can be properties not yet defined or any required property. | **bool:** <br> If the dependency have been succesfully added. |
| **validate** | **file_path -> String:** <br> File path to the JSON file. | Checks if the file exists, if it contains a valid JSON dictionary, and then checks all the conditions. | Nothing. |
| **has_errors** | None. | Checks if the validation process has raised any error. | **bool:** <br> If the validation process has raised any error. |
| **get_errors** | None. | Returns the errors raised by the validation process. | **Array:** <br> List of the errors raised by the validation process. |
| **has_warnings** | None. | Checks if the validation process has raised any warning. | **bool:** <br> If the validation process has raised any warning. |
| **get_warnings** | None. | Returns the warnings raised by the validation process. | **Array:** <br> List of the warnings raised by the validation process. |
| **get_result** | None. | Returns the result obtained by the validation process. | **Variant:** <br> Result obtained by the validation process. |