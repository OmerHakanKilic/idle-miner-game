extends StaticBody2D

var durability:int=1
var type:String
var player:Area2D
var randomNumber:int
var grassTexture:Texture2D=preload("res://Assets/Sprites/Blocks/Grass Block.png")
var dirtTexture:Texture2D=preload("res://Assets/Sprites/Blocks/Dirt Block.png")

#returns 2 state: has durability=1, doesn't have durability=0
func mined():
	print("Mined "+type)
	if(durability<=0):
		match type:
			"grass":
				Globals.grassAmount+=Globals.miningMultiplier
				print("Added "+type)
			"dirt":
				Globals.dirtAmount+=Globals.miningMultiplier
			"stone":
				Globals.stoneAmount+=Globals.miningMultiplier
		self.queue_free()
	elif(durability>0):
		durability-=Globals.miningPower
		return 1

func setType():
	randomNumber=randi_range(0,(Globals.grassRarityWeight+Globals.dirtRarityWeight+Globals.stoneRarityWeight))
	if randomNumber<=Globals.grassRarityWeight:#grass
		type="grass"
		durability=1
		$Sprite2D.texture=grassTexture
	elif randomNumber<=Globals.grassRarityWeight+Globals.dirtRarityWeight:#dirt
		type="dirt"
		durability=3
		$Sprite2D.texture=dirtTexture
	else:#stone
		type="stone"
