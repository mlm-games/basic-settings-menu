# Basic Settings Menu


A minimal and efficient settings menu plugin for Godot games

## Quick Links (After approval)

<p align="center">
  <a href="#">Asset Library Link</a>
</p>

## What is Basic Settings Menu?

Basic Settings Menu is a lightweight plugin for Godot that provides a ready-to-use settings menu implementation with the most common settings needed for 2D games. It's designed to be easily integrated into any Godot project while maintaining minimal memory footprint and quick loading times.

## Features

- Quick and easy implementation of common game settings
- Optimized for memory usage and loading time
- Flexible integration options:
  - Use as a scene change
  - Display as a popup overlay
- Automatic settings persistence through save files
- Efficient autoload system for settings management
- Easy to extend with custom settings (Currently not as easy but hope to in the future)

## Installation

1. Download from the Godot Asset Library
2. Enable the plugin in Project Settings -> Plugins
3. The settings menu will be ready to use in your project

## Usage

### Basic Implementation

```gdscript
# Change to settings scene
func _on_settings_button_pressed():
    SettingsData.change_scene_to_settings()

# Or display as popup
func _on_settings_button_pressed():
    SettingsData.show_settings_popup()
```

### Loading Settings

The plugin includes an autoload node (SettingsData) that handles:
- Initial settings file creation
- Loading saved settings on game launch
- Settings persistence between sessions

## Notes

- Could add the settings scene as an autoload but would advise otherwise to maintain optimal performance

## Version

Current Version: 0.9.2

## License

This project uses the [MIT License](LICENSE.md)
```
