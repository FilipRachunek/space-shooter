extends Node3D


@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.capture_mouse()
	OptionsManager.calculate_window_size()
	OptionsManager.set_window_mode()
	OptionsManager.resize_window()
	OptionsManager.set_v_sync_mode()
	OptionsManager.set_locale()
	SoundManager.init_sound_system()
	SoundManager.fade_in_intro_song()
	animation_player.play("author_fade_in_out")


func _unhandled_key_input(event):
	if event.is_pressed():
		launch_menu_scene()


func _on_animation_player_animation_finished(_anim_name):
	launch_menu_scene()


func launch_menu_scene():
	get_tree().change_scene_to_file("res://menu.tscn")
