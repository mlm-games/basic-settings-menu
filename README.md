# basic-settings-menu
An addon to add the most basic settings that are common to the editor or for most games (in 2D?)

After adding the plugin, to use the settings scene, just add a change_scene fn to settings or open it over your current screen like a popup.

To load the settings after lauching the game, just open the settings scene in the background and then close it when the ready signal is emitted, (the ready fn initials the save file and loads the settings from the save)

You could add it as a autoload but would advise avoiding that if possible as that would cost a little in terms of game memory and initial loading time

Use any config path like below example with the settings scene path:

    const CONFIG_PATH: String ="user://settings.tres"
    const SettingsScene: String = "res://addons/basic_setings_menu/settings.tscn"

Here is an example for loading and saving the settings:
```gdscript
func _ready():
	load_settings(true)


func save_settings() -> void:
	var new_save := GameSettingsSave.new()
	new_save.first_time_setup = first_time_setup
	new_save.accessibility = accessibility.duplicate(true)
	new_save.gameplay_options = gameplay_options.duplicate(true)
	new_save.video = video.duplicate(true)
	new_save.audio = audio.duplicate(true)
	
	#get_or_create_dir(CONFIG_DIR)
	var save_result := ResourceSaver.save(new_save, CONFIG_PATH)
	
	if save_result != OK:
		push_error("Failed to save settings to: %s" % CONFIG_PATH)
	else:
		print("Settings successfully saved to: %s" % CONFIG_PATH)

func load_settings(with_ui_update : bool = false) -> bool:
	if !ResourceLoader.exists(CONFIG_PATH):
		print("Settings save file not found.")
		if with_ui_update == true:
			var settings_instance = load(SettingsScene).instantiate()
			add_child(settings_instance)
			#await settings_instance.sign
			remove_child(settings_instance)
			settings_instance.queue_free()
		return false
	
	print("Settings file was found.")
	var new_load: GameSettingsSave = ResourceLoader.load(CONFIG_PATH, "Resource", ResourceLoader.CACHE_MODE_REUSE)
	
	if new_load == null:
		push_error("Failed to load settings from: %s" % CONFIG_PATH)
		return false
	
	first_time_setup = new_load.first_time_setup
	accessibility = new_load.accessibility.duplicate(true)
	gameplay_options = new_load.gameplay_options.duplicate(true)
	video = new_load.video.duplicate(true)
	audio = new_load.audio.duplicate(true)
	
	if with_ui_update == true:
		var settings_instance = load(SettingsScene).instantiate()
		add_child(settings_instance)
		#await settings_instance.sign
		remove_child(settings_instance)
		settings_instance.queue_free()
	
	return true
