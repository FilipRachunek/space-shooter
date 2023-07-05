extends Node


func _input(_event):
	if Input.is_action_just_pressed("resume_game"):
		if get_tree().paused:
			GameManager.reset_game_environment()
			get_tree().paused = false
