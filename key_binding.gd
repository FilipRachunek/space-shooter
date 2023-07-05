extends Node3D


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")


func _on_restore_default_button_pressed():
	KeyManager.reset_keymap()
	# refresh UI
	for item in Utils.get_all_children($CanvasLayer/ControlsContainer):
		if item is KeyBindingButton:
			item.display_current_key()
