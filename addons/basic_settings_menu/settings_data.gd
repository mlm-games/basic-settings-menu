extends Node

const CONFIG_PATH: String ="user://settings.tres"
const SettingsScene: String = "res://addons/basic_setings_menu/settings.tscn"


var first_time_setup: bool = true

var accessibility: Dictionary = {
	"current_locale": "en",
	"small_text_font_size": 20,
	"big_text_font_size": 64,
}
var gameplay_options: Dictionary = {
	"max_fps": 60,
	"pause_on_lost_focus": true,
}
var video: Dictionary = {
	"borderless": false,
	"fullscreen": true,
	"resolution": Vector2i(1080, 720),
}
var audio: Dictionary = {
	"Master": 100,
	"Music": 100,
	"SFX": 100,
}

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

func go_back_to_previous_scene_or_main_scene():
	get_tree().change_scene_to_file(ProjectSettings.get_setting("application/run/main_scene"))

func exit_settings(settings_scene: SettingsUI):
	settings_scene.queue_free()
