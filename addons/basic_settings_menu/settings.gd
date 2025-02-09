#TODO: ADD ICONS SAYING ESC FOR BACK, ENTER FOR SELECT
#TODO: ADD pause_on_alt_tab
#TODO: VolumeSliders makes sound when changed indicating the sound change
class_name SettingsUI extends Control

const BUS_MASTER = "Master"
const BUS_MUSIC = "Music"
const BUS_SFX = "SFX"

var awaiting_input : bool = false
var is_pop_up : bool = false

@onready var language_options_button: OptionButton = %LanguageOptionsButton

var locales := {
	"en": "English",
	"fr": "French / Français",
	"es": "Spanish / Español",
	"de": "German / Deutsch",
	"it": "Italian / Italiano",
	"br": "Portuguese / Português (BR)",
	"pt": "Portuguese / Português (PT)",
	"ru": "Russian / Русский",
	"el": "Greek / Ελληνικά",
	"tr": "Turkish / Türkçe",
	"da": "Danish / Dansk",
	"nb": "Norwegian (NB) / Norsk Bokmål",
	"sv": "Swedish / Svenska",
	"nl": "Dutch / Nederlands",
	"pl": "Polish / Polski",
	"fi": "Finnish / Suomi",
	"ja": "Japanese / 日本語",
	"zh": "Simplified Chinese / 简体中文",
	"lzh": "Traditional Chinese / 繁体中文",
	"ko": "Korean / 한국어",
	"cs": "Czech / Čeština",
	"hu": "Hungarian / Magyar",
	"ro": "Romanian / Română",
	"th": "Thai / ภาษาไทย",
	"bg": "Bulgarian / Български",
	"he": "Hebrew / עברית",
	"ar": "Arabic / العربية",
	"bs": "Bosnian"
}

@export var resolutions_array : Array[Vector2i] = [
	Vector2i(640, 360),
	Vector2i(960, 540),
	Vector2i(1024, 576),
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2048, 1152),
	Vector2i(2560, 1440),
	Vector2i(3200, 1800),
	Vector2i(3840, 2160),
]


func _ready() -> void:
	language_options_button.grab_focus()
	languages_ready()
	video_ready()
	gameplay_ready()
	audio_ready()
	ready.emit()

#region Accessibility

func languages_ready() -> void:
	var current_locale = TranslationServer.get_locale()
	var saved_locale_index := 0
	
	for locale in locales:
		language_options_button.add_item(locales[locale])
		language_options_button.set_item_metadata(language_options_button.get_item_count() - 1, locale)
		if current_locale.begins_with(locale):
			saved_locale_index = language_options_button.get_item_count() - 1
	
	language_options_button.select(saved_locale_index)

func handle_locale_mismatch(current_locale: String) -> String:
	# Iterate through locales and find a matching language code
	for locale in locales:
		if current_locale.begins_with(locale):
			return locale

	# If no match is found, use the default locale
	return locales.keys()[0]

#endregion

#region Gameplay

func gameplay_ready() -> void:
	%MaxFPSSpinBox.value = SettingsData.gameplay_options["max_fps"]
	Engine.set_max_fps(%MaxFPSSpinBox.value)

#endregion

#region Video

func video_ready():
	
	var window : Window = get_window()
	window.connect("size_changed", _preselect_resolution.bind(window))
	_update_ui()
	for resolution in resolutions_array:
		var resolution_string : String = "%d x %d" % [resolution.x, resolution.y]
		%ResolutionButton.add_item(resolution_string)

func _update_ui(window : Window = get_window()):
	%FullscreenButton.button_pressed = SettingsData.video["fullscreen"]
	if !SettingsData.video["fullscreen"]:
			var ws = SettingsData.video["resolution"]
			window.size = ws
			var ss = DisplayServer.screen_get_size()
			window.position = ss*0.5-ws*0.5

	_preselect_resolution(window)
	_update_resolution_options_enabled()

func _preselect_resolution(window : Window):
	%ResolutionButton.text = str(window.size)
	SettingsData.video["resolution"] = window.size

func _update_resolution_options_enabled():
	if OS.has_feature("web"):
		%ResolutionButton.disabled = true
		%ResolutionButton.tooltip_text = "Disabled for web"
	elif SettingsData.video["fullscreen"]:
		%ResolutionButton.disabled = true
		%ResolutionButton.tooltip_text = "Disabled for fullscreen"
	else:
		%ResolutionButton.disabled = false
		%ResolutionButton.tooltip_text = "Select a screen size"

#endregion

#region Audio

func audio_ready() -> void:
	%MainVolumeSlider.value = SettingsData.audio["Master"]
	%MusicSlider.value = SettingsData.audio["Music"]
	%SFXSlider.value = SettingsData.audio["SFX"]


func on_audio_value_changed(bus: String ,value: float) -> void:
	var _audio_bus = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(_audio_bus, linear_to_db(value))
	SettingsData.audio[bus] = value


func _on_main_volume_slider_drag_ended(_value_changed: bool) -> void:
	on_audio_value_changed(BUS_MASTER, %MainVolumeSlider.value)
	#%MasterBeepPlayer.play()

func _on_music_slider_drag_ended(_value_changed: bool) -> void:
	on_audio_value_changed(BUS_MUSIC, %MusicSlider.value)
	#%MusicBeepPlayer.play()

func _on_sfx_slider_drag_ended(_value_changed: bool) -> void:
	on_audio_value_changed(BUS_SFX, %SFXSlider.value)
	#%SFXBeepPlayer.play()

#endregion

#region signalled functions

func _on_max_fps_spin_box_value_changed(value: int) -> void:
	Engine.max_fps = value
	SettingsData.video["max_fps"] = value

func _on_resolution_button_item_selected(index: int) -> void:
	DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	var ws = resolutions_array[index]
	DisplayServer.window_set_size(ws)
	var ss = DisplayServer.screen_get_size()
	DisplayServer.window_set_position(ss*0.5-ws*0.5)
	

func _on_back_button_pressed() -> void:
	if is_pop_up:
		SettingsData.exit_settings(self)
	# Leaves without saving
	SettingsData.go_back()
	#Set the scene to change to.


func _on_borderless_button_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag( DisplayServer.WINDOW_FLAG_BORDERLESS,toggled_on )
	SettingsData.video["borderless"] = toggled_on


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		var ws = Vector2(1920, 1080)
		DisplayServer.window_set_size(ws)
		var ss = DisplayServer.screen_get_size()
		DisplayServer.window_set_position(ss*0.5-ws*0.5)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, SettingsData.video["borderless"])
	
	SettingsData.video["fullscreen"] = toggled_on
	_update_resolution_options_enabled()


func _on_language_options_button_item_selected(index: int) -> void:
	var locale: String = %LanguageOptionsButton.get_item_metadata(index)
	TranslationServer.set_locale(locale)
	SettingsData.accessibility["current_locale"] = locale
	#FIXME: _update_ui()


func _on_save_button_pressed() -> void:
	SettingsData.save_settings()
