extends Label

const c = RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME
const v = RenderingServer.RENDERING_INFO_VIDEO_MEM_USED

@export var show_debug = true # to turn it on/off in Inspector

var FPS = 0
var draw_calls = 0
var frame_time = 0
var VRAM = 0
var player
var small_star_count = 0

# This function will be called after the player is added.
func init(_player):
	player = _player

# Called by Godot on every frame.
func _process(delta):
	if not show_debug:
		text = ""
		return
	FPS = Engine.get_frames_per_second()
	draw_calls = RenderingServer.get_rendering_info(c)
	frame_time = delta
	VRAM = RenderingServer.get_rendering_info(v) / 1024.0 / 1024.0
	small_star_count = get_tree().get_nodes_in_group("small_star").size()
	var data = "FPS: " + str(FPS) + "\n" + \
		"Draw calls: " + str(draw_calls) + "\n" + \
		"Frame time: " + str(frame_time) + "\n" + \
		"VRAM: " + str(VRAM) + "\n" + \
		"Small stars: " + str(small_star_count) + "\n"
	if Utils.is_valid_node(player):
		data += "Position: " + str(player.global_position) + "\n" + \
		"Rotation: " + str(player.rotation)
	# Assign the debug info to the property text to display it.
	text = data
