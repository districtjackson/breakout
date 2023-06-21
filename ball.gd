extends RigidBody2D

signal miss

@export var start_delay = 2
@export var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartTimer.start(start_delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(position.x >= 1000):
		miss.emit()
		queue_free()

func _on_start_timer_timeout():
	var random_x
	
	# This if statement allows for it not choose any values between -0.5 and 0.5, as then the ball could be served vertically. Might change it to serve straight up though, we'll see
	if(randi() % 2 == 0):
		random_x = randf_range(0.5, 1)
	else:
		random_x = randf_range(-1, -0.5)
	
	var serve_vector = Vector2(random_x, -1) * speed

	apply_central_impulse(serve_vector) 


func _on_body_entered(body):
	pass


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Body Entered")
	if body is Area2D:
		print("Hit Paddle")
