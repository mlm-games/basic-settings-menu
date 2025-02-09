# basic-settings-menu
An addon to add the most basic settings that are common to the editor or for most games (in 2D?)

After adding the plugin, to use the settings scene, just add a change_scene fn to settings or open it over your current screen like a popup.

To load the settings after lauching the game, the autoload (SettingsData) just opens the settings scene in the background and then closes it when the ready signal is emitted, (the ready fn initials the save file and loads the settings from the save)

You could add it as a autoload but would advise avoiding that if possible as that would cost a little in terms of game memory and initial loading time
