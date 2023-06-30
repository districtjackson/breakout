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


func _on_area_2d_area_shape_entered(_area_rid, area, area_shape_index, _local_shape_index):
	
	# Cancel out current vector
	var current_velocity = self.linear_velocity
	
	apply_central_impulse(-current_velocity) 
	
	# Apply new vector with same magnitude as previous one, 
	# but a direction based on where paddle was hit
	var collision_x_value = self.position.x - area.position.x 
	
	# The collision_x_value is being divided by size of the paddles's CollisionShape 
	# so that it should hopefully work even if I change the size of the paddle
	var new_velocity = Vector2(collision_x_value \
				/ area.shape_owner_get_owner(area_shape_index).shape.size.x, -1).normalized() \
				* current_velocity.length()
	
	apply_central_impulse(new_velocity)
