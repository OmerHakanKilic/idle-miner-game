extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_movement_speed_button_pressed():
	if(Globals.grassAmount>=10):
		Globals.movementSpeed+=50
		Globals.grassAmount-=10
		print("Movement speed upgraded to: "+str(Globals.movementSpeed))
	else:
		print("Not enough grass")


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/sandbox.tscn")


func _on_mining_speed_button_pressed():
	if(Globals.grassAmount>=10):
		Globals.miningSpeed-=0.2
		Globals.grassAmount-=10


func _on_stone_rarity_button_pressed():
	if(Globals.grassAmount>=10):
		Globals.stoneRarityWeight+=1
		Globals.grassAmount-=10


func _on_dirt_rarity_button_pressed():
	if(Globals.grassAmount>=10):
		Globals.dirtRarityWeight+=1
		Globals.grassAmount-=10


func _on_mining_power_button_pressed():
	if(Globals.grassAmount>=10):
		Globals.miningPower+=1
		Globals.grassAmount-=10
