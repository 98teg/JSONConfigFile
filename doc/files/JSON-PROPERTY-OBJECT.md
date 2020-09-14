# JSON Property Object
## Functions

The public methods of this class are:

| Name | Params | Description | Returns |
|-|-|-|-|
| **set_preprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute before the validation process. | Sets the process to execute before the validation process. | Nothing. |
| **set_postprocessor** | **processor -> JSONConfigProcessor:** <br> Object that defines the function to execute after the validation process. | Sets the process to execute after the validation process. | Nothing. |
| **add_property** | **name -> String:** <br> Name of the property. <br> **property -> JSONProperty:** <br> Object with the conditions of the property. <br> **required -> bool (true):** <br> Determines if the property is obligatory. <br> **default_value -> Variant (null):** <br> If the property is not present or if it does not meet the conditions, this is the value the result would have. | Adds a new property to the object. | Nothing. |
| **add_exclusivity** | **exclusive_properties -> Array:** <br> Array with the names of the exclusive properties. <br> **one_is_required -> bool (false):** <br> Determines if one of the exclusive properties must be present. | Two properties of the array of exclusive properties cannot be present simultaniously. <br><br> **WARNING**: The exclusive properties array cannot contain properties not yet defined or any required property. | **bool:** <br> If the exclusive properties have been succesfully added. |
| **add_dependency** | **main_property -> String:** <br> Name of the main property. <br> **dependent_property -> String:** <br> Name of the dependent property. | If the main property is present, the dependent property must be present too. <br><br> **WARNING**: Neither the main nor the dependent property can be properties not yet defined or any required property. | **bool:** <br> If the dependency have been succesfully added. |