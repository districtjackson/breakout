extends Node2D

@export var simulation_tps = 60
@export var brick_scene: PackedScene
@export var ball_scene: PackedScene
@export var number_of_brick_rows = 10

var remaining_bricks = 0
var lives = 0
var paddle_narrowed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_physics_ticks_per_second(simulation_tps)
	
# Setup and start game
func _start():
	# Reset game states
	lives = 3
	if(paddle_narrowed):
		$Paddle.change_size()
		paddle_narrowed = false
		
	_get_high_score()
	_generate_bricks()
	_spawn_ball()
	$Paddle.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_ball_brick_destroyed():
	remaining_bricks -= 1
	$HUD.increase_score()
	
	if(remaining_bricks <= 0):
		_generate_bricks()
	
func _generate_bricks():
	print("Generating Bricks")
	
	var bricks_added = 0
	
	# Rows
	for i in range(110, 110 + (number_of_brick_rows * 20), 20):
		
		var row_color = _generate_color()
		
		print(row_color)
		
		# Columns
		for j in range(50,775,50):	
			var brick = brick_scene.instantiate()
			add_child(brick)
			
			brick.position = Vector2(j, i)
			brick.modulate = row_color
			
			bricks_added += 1
	
	# Add number of new bricks to remaining brick count
	remaining_bricks += bricks_added

# Use this to generate random neon colors
func _generate_color():
	
	var red = randf_range(.6, 1)
	var green = randf_range(.6, 1)
	var blue = randf_range(.6, 1)
	
	# Determines which value to make smaller, as neon colors have two of the rgb parameters
	# with high values and one with low
	var null_determiner = randf()
	
	# Chooses whether one or two colors value's are lowered
	if(randf() > 0.5): # One
		if(null_determiner < .33):
			red = randf_range(0, .3)
		elif(null_determiner < .67):
			green = randf_range(0, .3)
		else:
			blue = randf_range(0, .3)
	else: # Two
		if(null_determiner < .33):
			red = randf_range(0, .3)
			green = randf_range(0, .3)
		elif(null_determiner < .67):
			green = randf_range(0, .3)
			blue = randf_range(0, .3)
		else:
			red = randf_range(0, .3)
			blue = randf_range(0, .3)
	
	return Color(red, green, blue)

func _on_ceiling_hit():
	if(!paddle_narrowed):
		$Paddle.change_size()
		paddle_narrowed = true

func _on_ball_miss():
	lives -= 1
	
	if(lives <= 0):
		_game_over()	
	else: # If lives remaining, decrease score counter and spawn new ball
		$HUD.change_lives(lives)
		_spawn_ball()
	
	# Unshrink paddle
	if(paddle_narrowed):
		$Paddle.change_size()
		paddle_narrowed = false
		
func _spawn_ball():
	var ball = ball_scene.instantiate()
	add_child(ball)
	
	ball.position = Vector2(400, 400)
	# Reconnect ball's signals to main
	ball.brick_destroyed.connect(_on_ball_brick_destroyed)
	ball.miss.connect(_on_ball_miss)
	ball.ceiling_hit.connect(_on_ceiling_hit)
	
func _game_over():
	# Delete all remaining bricks
	for i in self.get_children():
		if(i.has_method("destroy")):
			i.queue_free()
		
	$HUD.game_over()
	$Paddle.hide()

# Saves provided high score at user://breakout.save
func _save_high_score(high_score):
	print("Saving game...")
	
	var save_dict = {
		"score" : high_score
	}
	
	var save = FileAccess.open("user://breakout.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save_dict)
	
	save.store_line(json_string)
	
	print("High score saved")
	
	return
	
func _get_high_score():
	# See if a save high score even exists
	if not FileAccess.file_exists("user://breakout.save"):
		print("Save game file does not exist")
		return # Error! We don't have a save to load.

	# Open save file
	var save = FileAccess.open("user://breakout.save", FileAccess.READ)
	
	# Get JSON line
	var json_string = save.get_line()
	
	# Helper class to interact with JSON
	var json = JSON.new()
	
	# Error checking
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	
	# Get data from JSON object
	var node_data = json.get_data()
	
	$HUD.set_high_score(node_data["score"])
	
	print("High Score Retrieved")
	
	return
