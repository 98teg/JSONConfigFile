# JSON Configuration File

## Index

## Introduction

JSON Configuration File is a plugin for Godot that aims to aid reading user input via a JSON file. It uses three types of classes for this purpose:

* **JSONConfigFile:** The main class of this plugin. This class would read the user input file, detecting its potential errors. This class also returns the dictionary obtained. It works by adding properties of the desired JSON structure via code.
* **JSONProperty:** The class that defines what restrictions a given property has. This class itself does not apply any test to the user input, but every other property extends from this one. Here it is the list with the twelve types of properties based on this class, alongside the input they expect:
    * **JSONPropertyBool:** Booleans.
    * **JSONPropertyNumber:** Real numbers.
    * **JSONPropertyInteger:** Integers.
    * **JSONPropertyPercentage:** Real numbers, in the range [0, 1].
    * **JSONPropertyString:** Strings.
    * **JSONPropertyEnum:** Strings from an array of possible values.
    * **JSONPropertyArray:** Arrays.
    * **JSONPropertyColor:** Arrays with 3 to 4 elements. They represent a color in RGB or RGBA, with each value being an integer in the range [0, 255].
    * **JSONPropertyObject:** Dictionaries.
    * **JSONPropertyFile:** Strings representing a path to a file.
    * **JSONPropertyJSONConfigFile:** Strings representing a path to a JSON configuration file.
    * **JSONPropertyImage:** Strings representing a path to an image file.
* **JSONConfigProcessor:** The abstract class from which any custom process must extend. The functionality of this class is a bit advanced, but basically, it serves as a way to create functions to process the user input before or after the property tests.

## JSON Configuration File
### Class name: JSONConfigFile
### Description
<code class="language-gdscript" data-lang="gdscript">
func validate_json_file(json_file : String) -> JSONConfigFile:
	var json_config_file = JSONConfigFile.new()

	json_config_file.add_property("name", JSONPropertyString.new())
	json_config_file.add_property("age", JSONPropertyInteger.new())

	json_config_file.validate(json_file)

	return json_config_file
</code>

### Functions
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

## JSON Property
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_preprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute before the validation process. | Sets the process to execute before the validation process. | Nothing. |
| **set_postprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute after the validation process. | Sets the process to execute after the validation process. | Nothing. |
## JSON Property Bool

## JSON Property Number
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_min_value** | **min_value -> float:** <br> The minimum value allowed. | Sets the minimum value allowed. | Nothing. |
| **remove_min_value** | None. | Removes any minimum boundary. | Nothing. |
| **set_max_value** | **max_value -> float:** <br> The maximum value allowed. | Sets the maximum value allowed. | Nothing. |
| **remove_max_value** | None. | Removes any maximum boundary. | Nothing. |

## JSON Property Integer
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_min_value** | **min_value -> int:** <br> The minimum value allowed. | Sets the minimum value allowed. | Nothing. |
| **remove_min_value** | None. | Removes any minimum boundary. | Nothing. |
| **set_max_value** | **max_value -> int:** <br> The maximum value allowed. | Sets the maximum value allowed. | Nothing. |
| **remove_max_value** | None. | Removes any maximum boundary. | Nothing. |

## JSON Property Percentage

## JSON Property String
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_min_length** | **min_value -> int:** <br> The minimum length allowed for the string. | Sets the minimum length allowed. | Nothing. |
| **remove_min_length** | None. | Removes any minimum length boundary. | Nothing. |
| **set_max_length** | **max_value -> int:** <br> The maximum length allowed for the string. | Sets the maximum length allowed. | Nothing. |
| **remove_max_length** | None. | Removes any maximum length boundary. | Nothing. |
| **set_pattern** | **pattern -> String:** <br> The pattern the string must contain. <br><br> **NOTE:** Check [RegEx](https://docs.godotengine.org/en/stable/classes/class_regex.html?highlight=RegEx#regex) for more information. | Sets the pattern the string must contain. | **int:** <br> The result of compiling the pattern. <br><br> **NOTE:** Check [RegEx.compile](https://docs.godotengine.org/en/stable/classes/class_regex.html?highlight=RegEx#class-regex-method-compile) for more information. |
| **remove_pattern** | None. | Removes any pattern. | Nothing. |

## JSON Property Enum
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_enum** | **list -> Array:** <br> Array of strings with the values that are allowed in this field. | Sets the list of values that are allowed in this field. | Nothing. |

## JSON Property Array
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_min_size** | **min_value -> int:** <br> The minimum size allowed for the array. | Sets the minimum size allowed. | Nothing. |
| **remove_min_size** | None. | Removes any minimum size boundary. | Nothing. |
| **set_max_size** | **max_value -> int:** <br> The maximum size allowed for the array. | Sets the maximum size allowed. | Nothing. |
| **remove_max_size** | None. | Removes any maximum size boundary. | Nothing. |
| **set_element_property** | **element_property -> JSONProperty:** <br> Object with the conditions that every element of the array must satisfy. | Sets the conditions that every element of the array must satisfy. | Nothing. |
| **remove_element_property** | None. | Allows the elements of the array to be anything. | Nothing. |
| **set_uniqueness** | **uniqueness -> bool:** <br> Determines if every object of the array must be different from each other. <br> **unique_key -> String (""):** <br> If the array has dictionaries as its elements, 'unique_key' determines which property to use when comparing if two of then are equal. <br><br> **WARNING:** An empty 'unique_key' means that every property of the dictionaries must be equal for them to be equal. | Determines if the elements of the array have to be unique. | Nothing.

## JSON Property Color

## JSON Property Object
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **add_property** | **name -> String:** <br> Name of the property. <br> **property -> JSONProperty:** <br> Object with the conditions of the property. <br> **required -> bool (true):** <br> Determines if the property is obligatory. <br> **default_value -> Variant (null):** <br> If the property is not present or if it does not meet the conditions, this is the value the result would have. | Adds a new property to the object. | Nothing. |
| **add_exclusivity** | **exclusive_properties -> Array:** <br> Array with the names of the exclusive properties. <br> **one_is_required -> bool (false):** <br> Determines if one of the exclusive properties must be present. | Two properties of the array of exclusive properties cannot be present simultaniously. <br><br> **WARNING**: The exclusive properties array cannot contain properties not yet defined or any required property. | **bool:** <br> If the exclusive properties have been succesfully added. |
| **add_dependency** | **main_property -> String:** <br> Name of the main property. <br> **dependent_property -> String:** <br> Name of the dependent property. | If the main property is present, the dependent property must be present too. <br><br> **WARNING**: Neither the main nor the dependent property can be properties not yet defined or any required property. | **bool:** <br> If the dependency have been succesfully added. |

## JSON Property File
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_mode_flag** | **mode_flag -> int:** <br> The flag that determines how to open the file. <br><br> **NOTE:** Check [File.ModeFlags](https://docs.godotengine.org/en/stable/classes/class_file.html?highlight=File#enum-file-modeflags) for more information. | Determines how to open the file. | Nothing.

## JSON Property JSON Configuration File
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_json_config_file** | **json_config_file -> JSONConfigFile:** <br> Object that would validate the file indicated by the path that this field contains. | Sets the JSON COnfiguration File. | Nothing. |

## JSON Property Image
### Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_size** | **width -> int:** <br> Width of the image. <br> **height -> int:** <br> Height of the image. <br> **resizable -> bool(true):** <br> Determines if the image is resizable. If it is, it will raise a warning whenever the size of the input image is different than this size, and then it will resize the image. If it is not, it will raise an error instead. <br> **interpolation -> int(Image.INTERPOLATE_BILINEAR):** <br> Interpolation tecnich to apply whenever the size of the input image is different and it must be resized. <br><br> **NOTE:** Check [Image.Interpolation](https://docs.godotengine.org/en/stable/classes/class_image.html?highlight=Image#enum-image-interpolation) for more information. | Sets the recommended, or required, size of the image. | Nothing. |

## JSON Configuration Processors