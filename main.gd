extends Node2D

@export var simulation_tps = 60
@export var brick_scene: PackedScene

var remaining_bricks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_physics_ticks_per_second(simulation_tps)
	start() # Temporary, HUD will call this later
	
# Setup and start game
func start():
	_generate_bricks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_ball_brick_destroyed():
	remaining_bricks -= 1
	
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
		
	remaining_bricks += bricks_added
