# JSONPropertyString
## Functions
| Name | Params | Description | Returns |
|-|-|-|-|
| **set_preprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute before the validation process. | Sets the process to execute before the validation process. | Nothing. |
| **set_postprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute after the validation process. | Sets the process to execute after the validation process. | Nothing. |
| **set_min_length** | **min_value -> int:** <br> The minimum length allowed for the string. | Sets the minimum length allowed. | Nothing. |
| **remove_min_length** | None. | Removes any minimum length boundary. | Nothing. |
| **set_max_length** | **max_value -> int:** <br> The maximum length allowed for the string. | Sets the maximum length allowed. | Nothing. |
| **remove_max_length** | None. | Removes any maximum length boundary. | Nothing. |
| **set_pattern** | **pattern -> String:** <br> The pattern the string must contain. <br><br> **NOTE:** Check [RegEx](https://docs.godotengine.org/en/stable/classes/class_regex.html?highlight=RegEx#regex) for more information. | Sets the pattern the string must contain. | **int:** <br> The result of compiling the pattern. <br><br> **NOTE:** Check [RegEx.compile](https://docs.godotengine.org/en/stable/classes/class_regex.html?highlight=RegEx#class-regex-method-compile) for more information. |
| **remove_pattern** | None. | Removes any pattern. | Nothing. |