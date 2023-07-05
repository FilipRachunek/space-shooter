extends Node3D


@onready var logo_light = $LogoLight

var current_rotation = 0.0
var max_rotation = 3.0
var rotating = true


func _ready():
	SoundManager.fade_in_intro_song(64.0)
	GameManager.release_mouse()
	GameManager.set_boundary(
		$"Boundary/LeftWall".position.x,
		$"Boundary/RightWall".position.x,
		$"Boundary/TopWall".position.z,
		$"Boundary/BottomWall".position.z
	)
	GameManager.spawn_stars(self)


func _process(delta):
	GameManager.process_background(self, delta)
	if rotating:
		logo_light.rotate_x(delta)
		current_rotation += delta
		if rotating and current_rotation >= max_rotation:
			rotating = false


func _on_start_button_pressed():
	SoundManager.fade_out_intro_song()
	get_tree().change_scene_to_file("res://main.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")
