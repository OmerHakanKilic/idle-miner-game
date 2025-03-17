extends Node2D



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/upgrade_menu.tscn")


func _on_exit_button_pressed():
	get_tree().quit()


func _on_settings_button_pressed():
	pass # Replace with function body.
