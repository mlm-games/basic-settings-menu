@tool
class_name SettingOption
extends Resource

enum ControlType {
    CHECKBOX,
    SLIDER,
    SPINBOX,
    DROPDOWN,
    INPUT_FIELD
}

@export var name: String = ""
@export_group("Control Settings")
@export var control_type: ControlType:
    set(type):
        control_type = type
        notify_property_list_changed() # This will refresh the inspector

# These variables will be shown/hidden based on control_type
var bool_default: bool = false
var float_default: float = 0.0
var int_default: int = 0
var string_default: String = ""
var selected_option: int = 0

@export_group("Range Settings", "range_")
@export var range_min_value: float = 0.0
@export var range_max_value: float = 100.0
@export var range_step: float = 1.0

@export_group("Dropdown Settings")
@export var dropdown_options: PackedStringArray = PackedStringArray()

func _get_property_list() -> Array:
    var properties: Array = []
    
    # Add the appropriate default value property based on control_type
    match control_type:
        ControlType.CHECKBOX:
            properties.append({
                "name": "bool_default",
                "type": TYPE_BOOL,
                "usage": PROPERTY_USAGE_DEFAULT,
                "hint": PROPERTY_HINT_NONE,
            })
        ControlType.SLIDER, ControlType.SPINBOX:
            properties.append({
                "name": "float_default",
                "type": TYPE_FLOAT,
                "usage": PROPERTY_USAGE_DEFAULT,
                "hint": PROPERTY_HINT_RANGE,
                "hint_string": "%f,%f,%f" % [range_min_value, range_max_value, range_step]
            })
        ControlType.DROPDOWN:
            properties.append({
                "name": "selected_option",
                "type": TYPE_INT,
                "usage": PROPERTY_USAGE_DEFAULT,
                "hint": PROPERTY_HINT_ENUM,
                "hint_string": ",".join(dropdown_options)
            })
        ControlType.INPUT_FIELD:
            properties.append({
                "name": "string_default",
                "type": TYPE_STRING,
                "usage": PROPERTY_USAGE_DEFAULT,
            })
    
    return properties

# Helper function to get the current default value regardless of type
func get_default_value() -> Variant:
    match control_type:
        ControlType.CHECKBOX:
            return bool_default
        ControlType.SLIDER, ControlType.SPINBOX:
            return float_default
        ControlType.DROPDOWN:
            return selected_option
        ControlType.INPUT_FIELD:
            return string_default
    return null