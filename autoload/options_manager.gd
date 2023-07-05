extends Node


const options_path = "user://options.data"


var en_flag = preload("res://translations/flags/gb.png")
var cz_flag = preload("res://translations/flags/cz.png")

# feel free to add more entries
var window_size_list = [
	{ "width": 1024, "height": 768 },
	{ "width": 1280, "height": 720 },
	{ "width": 1366, "height": 768 },
	{ "width": 1600, "height": 900 },
	{ "width": 1920, "height": 1080 },
	{ "width": 2042, "height": 1152 },
	{ "width": 2560, "height": 1440 },
]

var v_sync_list = [
	{ "mode": DisplayServer.VSYNC_DISABLED, "label": "settings.vsync.disabled" },
	{ "mode": DisplayServer.VSYNC_ENABLED, "label": "settings.vsync.enabled" },
	{ "mode": DisplayServer.VSYNC_ADAPTIVE, "label": "settings.vsync.adaptive" },
	{ "mode": DisplayServer.VSYNC_MAILBOX, "label": "settings.vsync.mailbox" },
]

var locale_list = [
	{ "locale": "en", "label": "settings.language.en", "flag": en_flag },
	{ "locale": "cz", "label": "settings.language.cz", "flag": cz_flag },
]


func read_options():
	var options = {}
	var file = FileAccess.open(options_path, FileAccess.READ)
	if file:
		options = file.get_var()
		file.close()
	return options


func write_options(options):
	var file = FileAccess.open(options_path, FileAccess.WRITE)
	file.store_var(options)
	file.close()


func set_window_mode():
	var window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	var options = read_options()
	if options.has("full_screen"):
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN if options.full_screen else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(window_mode)
	write_options(options)


func resize_window():
	var options = read_options()
	if not options.has("full_screen") or not options.full_screen:
		var window_size = Vector2i(options.window_width, options.window_height)
		var screen_size = DisplayServer.screen_get_size()
		get_window().size = window_size
		DisplayServer.window_set_position(Vector2i((screen_size.x - window_size.x) / 2, (screen_size.y - window_size.y) / 2))


func set_v_sync_mode():
	var options = read_options()
	if not options.has("v_sync"):
		options.v_sync = DisplayServer.VSYNC_ENABLED
	DisplayServer.window_set_vsync_mode(options.v_sync)
	write_options(options)


func calculate_window_size():
	var options = read_options()
	var screen_size = DisplayServer.screen_get_size()
	var window_width = screen_size.x
	var window_height = screen_size.y
	if options.has("window_width") and options.has("window_height"):
		window_width = options.window_width
		window_height = options.window_height
	else:
		for size in window_size_list:
			# find the biggest window to fit the screen
			if size.width < window_width:
				window_width = size.width
				window_height = size.height
		options.window_width = window_width
		options.window_height = window_height
		write_options(options)


func set_locale():
	var options = read_options()
	if not options.has("locale"):
		options.locale = "en"  # default locale
	TranslationServer.set_locale(options.locale)
	write_options(options)
