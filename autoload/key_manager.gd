extends Node


const DEFAULT_KEY_MAP = {
	"move_up": [KEY_W, KEY_UP],
	"move_left": [KEY_A, KEY_LEFT],
	"move_down": [KEY_S, KEY_DOWN],
	"move_right": [KEY_D, KEY_RIGHT],
	"accelerate": [KEY_SHIFT],
	"shoot_primary": [MOUSE_BUTTON_LEFT, KEY_SPACE],
	"shoot_secondary": [MOUSE_BUTTON_RIGHT, KEY_Q],
	"pause_game": [KEY_P],
	"resume_game": [KEY_ENTER, KEY_KP_ENTER],
}
const keymaps_path = "user://keymaps.dat"


var keymaps: Dictionary


func _ready():
	for action in InputMap.get_actions():
		if InputMap.action_get_events(action).size() != 0:
			keymaps[action] = InputMap.action_get_events(action)
	load_keymap()


func load_keymap():
	if not FileAccess.file_exists(keymaps_path):
		reset_keymap() # there is no save file yet, so let's create one with default values
		return
	var file = FileAccess.open(keymaps_path, FileAccess.READ)
	var temp_keymap = file.get_var(true) as Dictionary
	file.close()
	for action in keymaps.keys():
		if temp_keymap.has(action):
			keymaps[action] = temp_keymap[action]
			InputMap.action_erase_events(action)
			for event in keymaps[action]:
				InputMap.action_add_event(action, event)


func save_keymap():
	var file = FileAccess.open(keymaps_path, FileAccess.WRITE)
	file.store_var(keymaps, true)
	file.close()


func reset_keymap():
	for action in DEFAULT_KEY_MAP:
		InputMap.action_erase_events(action)
		var events = []
		for key in DEFAULT_KEY_MAP[action]:
			var event
			if key == MOUSE_BUTTON_LEFT or key == MOUSE_BUTTON_MIDDLE or key == MOUSE_BUTTON_RIGHT:
				event = InputEventMouseButton.new()
				event.set_button_index(key)
			else:
				event = InputEventKey.new()
				event.set_keycode(key)
			if event:
				events.append(event)
				InputMap.action_add_event(action, event)
			keymaps[action] = events
	save_keymap()
