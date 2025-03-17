extends CharacterBody2D

#Swipe variables
const SWIPELENGHT=50
const THRESHOLD=10
var swipeStartPosition:Vector2
var swipeCurrentPosition:Vector2
var swiping:bool=false

var direction:String="Right"
var current_target
var turnbuffer:String

#Block generation variables
var last_generation_position: Vector2
var current_block_positions={}
var blockscene=preload("res://Scenes/block.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Mining Cooldown".wait_time=Globals.miningSpeed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_block_spawn()
	handle_swipe()
	handle_input()
	handle_movement()
	handleBuffer()
	move_and_slide()

func handle_swipe():
	if Input.is_action_just_pressed("Press"):
		if !swiping:
			swiping=true
			swipeStartPosition=get_global_mouse_position()
	if Input.is_action_pressed("Press"):
		if swiping:
			swipeCurrentPosition=get_global_mouse_position()
			if swipeStartPosition.distance_to(swipeCurrentPosition)>=SWIPELENGHT:
				var tempSwipeX=swipeStartPosition.x-swipeCurrentPosition.x
				var tempSwipeY=swipeStartPosition.y-swipeCurrentPosition.y
				if(abs(tempSwipeY)<abs(tempSwipeX)):
					if(tempSwipeX<0):
						direction="Right"
						$"Digging Hitbox".global_position.x=$".".global_position.x
						$"Digging Hitbox".global_position.y=$".".global_position.y
					elif(tempSwipeX>0):
						direction="Left"
						$"Digging Hitbox".global_position.x=$".".global_position.x-24
						$"Digging Hitbox".global_position.y=$".".global_position.y
				elif(abs(tempSwipeY)>abs(tempSwipeX)):
					if(tempSwipeY<0):
						direction="Down"
						$"Digging Hitbox".global_position.y=$".".global_position.y+12
						$"Digging Hitbox".global_position.x=$".".global_position.x-12
					elif(tempSwipeY>0):
						direction="Up"
						$"Digging Hitbox".global_position.y=$".".global_position.y-12
						$"Digging Hitbox".global_position.x=$".".global_position.x-12
				
			
func handle_input():
	if(Input.is_action_just_pressed("ui_left") and direction!="Left"):
		if(turnbuffer=="Left" and canTurnX()==true):
			turnbuffer=""
			direction="Left"
			$"Digging Hitbox".global_position.x=$".".global_position.x-24
			$"Digging Hitbox".global_position.y=$".".global_position.y
		else:
			turnbuffer="Left"
	if(Input.is_action_just_pressed("ui_right")and direction!="Right"):
		if(turnbuffer=="Right" and canTurnX()==true):
			direction="Right"
			$"Digging Hitbox".global_position.x=$".".global_position.x
			$"Digging Hitbox".global_position.y=$".".global_position.y
		else:
			turnbuffer="Right"
	if(Input.is_action_just_pressed("ui_up")and direction!="Up"):
		if(turnbuffer=="Up" and canTurnY()==true):
			direction="Up"
			$"Digging Hitbox".global_position.y=$".".global_position.y-12
			$"Digging Hitbox".global_position.x=$".".global_position.x-12
		else:
			turnbuffer="Up"
	if(Input.is_action_just_pressed("ui_down")and direction!="Down"):
		if(turnbuffer=="Down" and canTurnY()==true):
			direction="Down"
			$"Digging Hitbox".global_position.y=$".".global_position.y+12
			$"Digging Hitbox".global_position.x=$".".global_position.x-12
		else:
			turnbuffer="Down"

func handle_movement():
	if(direction=="Left"):
		velocity.x=-Globals.movementSpeed
		
	elif(direction=="Right"):
		velocity.x=Globals.movementSpeed
		
	else:
		velocity.x=0
	if(direction=="Up"):
		velocity.y=-Globals.movementSpeed
	elif(direction=="Down"):
		velocity.y=Globals.movementSpeed
	else:
		velocity.y=0

func _on_digging_hitbox_body_entered(body):
	print("body entered"+body.name)
	if(body.is_in_group("Blocks")):
		current_target=body
		start_mining()


func start_mining():
		$"Mining Cooldown".start()
		print("timer started")
	
func continue_mining():
	$"Mining Cooldown".start()
func _on_mining_cooldown_timeout():
	print("timer run out")
	var temp=current_target.mined()
	if(temp==1):
		continue_mining()
		
func handle_block_spawn():
	# Only spawn if player has moved 48 pixels (3 tiles) from last spawn point
	if (position-last_generation_position).length() < 16:
		return
	# Calculate player's grid position
	var player_grid = Vector2i(position / 16)
	
	# Define grid bounds (15x7 grid centered on the player)
	var start_x = player_grid.x - 7  # 7 tiles left
	var end_x = player_grid.x + 7    # 7 tiles right
	var start_y = player_grid.y - 3  # 3 tiles up
	var end_y = player_grid.y + 3    # 3 tiles down
	
	# Generate blocks in the grid
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			# Skip the player's current grid cell
			if x == player_grid.x && y == player_grid.y:
				continue
				# Convert grid to world position
			var world_pos = Vector2(x * 16, y * 16)
				# Spawn block if it doesn't exist
			if not current_block_positions.has(world_pos):
					spawn_block(world_pos.x, world_pos.y)
					# Update last generation position
					last_generation_position = position
func spawn_block(x:float,y:float):
	print("Block spawning...")
	var block=blockscene.instantiate()
	var tempVector=Vector2(x,y)
	block.position=tempVector
	block.setType()
	current_block_positions[tempVector]=block
	$"../Blocks".add_child(block)
func canTurnY():
	#under construction currently always returning true
	var xcalc=int(($".".global_position.x+8))%16
	xcalc=0
	if(xcalc==0):
		return true
	else:
		return false
func canTurnX():
	#under construction currently always returning true
	var ycalc=int(($".".global_position.y+8))%16
	ycalc=0
	if(ycalc==0):
		return true
	else:
		return false
func handleBuffer():
	if(turnbuffer=="Left" and canTurnX()==true):
		turnbuffer=""
		direction="Left"
		$"Digging Hitbox".global_position.x=$".".global_position.x-24
		$"Digging Hitbox".global_position.y=$".".global_position.y
	if(turnbuffer=="Right" and canTurnX()==true):
		turnbuffer=""
		direction="Right"
		$"Digging Hitbox".global_position.x=$".".global_position.x
		$"Digging Hitbox".global_position.y=$".".global_position.y
	if(turnbuffer=="Up" and canTurnY()==true):
		turnbuffer=""
		direction="Up"
		$"Digging Hitbox".global_position.y=$".".global_position.y-12
		$"Digging Hitbox".global_position.x=$".".global_position.x-12
	if(turnbuffer=="Down" and canTurnY()==true):
		turnbuffer=""
		direction="Down"
		$"Digging Hitbox".global_position.y=$".".global_position.y+12
		$"Digging Hitbox".global_position.x=$".".global_position.x-12
func _on_digging_hitbox_body_exited(body):
	if(body.is_in_group("Blocks")):
		$"Mining Cooldown".stop()
