extends Node2D

var levelTimeRemaining:int=30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"TopBar/MarginContainer/HBoxContainer/Grass Section/Grass Amount".text=str(Globals.grassAmount)
	if(levelTimeRemaining<=0):
		get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")


func _on_level_timer_timeout():
	levelTimeRemaining-=1
	$"TopBar/MarginContainer/HBoxContainer/Time Section/Time Amount".text=str(levelTimeRemaining)

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
