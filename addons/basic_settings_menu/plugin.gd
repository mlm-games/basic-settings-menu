@tool
extends EditorPlugin

var pluginPath: String = get_script().resource_path.get_base_dir()
const SettingsData: String = "/settings_data.gd"


func _enter_tree():
	add_autoload_singleton("SettingsData", pluginPath + SettingsData)
    add_custom_type("SettingOption", "Resource", 
                    preload("res://addons/basic_settings_menu/setting_option.gd"),
                    null)
    add_custom_type("SettingsCategory", "Resource",
                    preload("res://addons/basic_settings_menu/settings_category.gd"),
                    null)


func _exit_tree():
	remove_autoload_singleton("SettingsData")
