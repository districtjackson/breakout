extends Node2D

@export var simulation_tps = 60
@export var brick_scene: PackedScene
@export var ball_scene: PackedScene

var remaining_bricks = 0
var lives = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_physics_ticks_per_second(simulation_tps)
	
# Setup and start game
func _start():
	lives = 3
	_generate_bricks()
	_spawn_ball()

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
	
	for i in range(110, 310, 20):
		for j in range(50,775,50):	
			var brick = brick_scene.instantiate()
			add_child(brick)
			
			brick.position = Vector2(j, i)
			
			bricks_added += 1
	
	# Add number of new bricks to remaining brick count
	remaining_bricks += bricks_added

func _on_ball_miss():
	lives -= 1
	
	if(lives <= 0):
		_game_over()
	else: # If lives remaining, decrease score counter and spawn new ball
		$HUD.change_lives(lives)
		_spawn_ball()
		
func _spawn_ball():
	var ball = ball_scene.instantiate()
	add_child(ball)
	
	ball.position = Vector2(400, 400)
	# Reconnect ball's signals to main
	ball.brick_destroyed.connect(_on_ball_brick_destroyed)
	ball.miss.connect(_on_ball_miss)
	
func _game_over():
	# Delete all remaining bricks
	for i in self.get_children():
		if(i.has_method("destroy")):
			i.queue_free()
		
	$HUD.game_over()

