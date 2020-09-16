# JSON Property Array
## Functions

The public methods of this class are:

| Name | Params | Description | Returns |
|-|-|-|-|
| **set_preprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute before the validation process. | Sets the process to execute before the validation process. | Nothing. |
| **set_postprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute after the validation process. | Sets the process to execute after the validation process. | Nothing. |
| **set_min_size** | **min_value -> int:** <br> The minimum size allowed for the array. | Sets the minimum size allowed. | Nothing. |
| **remove_min_size** | None. | Removes any minimum size boundary. | Nothing. |
| **set_max_size** | **max_value -> int:** <br> The maximum size allowed for the array. | Sets the maximum size allowed. | Nothing. |
| **remove_max_size** | None. | Removes any maximum size boundary. | Nothing. |
| **set_element_property** | **element_property -> JSONProperty:** <br> Object with the conditions that every element of the array must satisfy. | Sets the conditions that every element of the array must satisfy. | Nothing. |
| **remove_element_property** | None. | Allows the elements of the array to be anything. | Nothing. |
| **set_uniqueness** | **uniqueness -> bool:** <br> Determines if every object of the array must be different from each other. <br> **unique_key -> String (""):** <br> If the array has dictionaries as its elements, 'unique_key' determines which property to use when comparing if two of then are equal. <br><br> **WARNING:** An empty 'unique_key' means that every property of the dictionaries must be the same for them to be equal. | Determines if the elements of the array have to be unique. | Nothing.