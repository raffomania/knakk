class_name SettingsObject


const CONFIG_FILE_PATH := "user://settings.cfg"

var dark_mode: bool


func save():
	var config = ConfigFile.new()
	config.set_value("general", "dark_mode", dark_mode)
	config.save(CONFIG_FILE_PATH)


static func load_from_file() -> SettingsObject:
	var config = ConfigFile.new()
	config.load(CONFIG_FILE_PATH)

	var settings = SettingsObject.new()
	settings.dark_mode = config.get_value("general", "dark_mode", false)

	return settings
