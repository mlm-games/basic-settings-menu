@tool
class_name SettingsCategory
extends Resource

@export var category_name: String = ""
@export var settings: Array[SettingOption] = []

# optional: Add icon to make it more visible in editor
@export var category_icon: Texture2D