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

func _on_area_2d_area_entered(area):
	var current_velocity = self.linear_velocity
	
	apply_central_impulse(-current_velocity) # Cancel out current vector
	
	# Apply new vector with same magnitude as previous one, but a direction based on where paddle was hit
	
	# apply_central_impulse()

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var body_shape_owner_id = area.shape_find_owner(area_shape_index)
	var body_shape_owner = area.shape_owner_get_owner(body_shape_owner_id)
	var body_shape_2d = area.shape_owner_get_shape(body_shape_owner_id, 0)
	var body_global_transform = body_shape_owner.global_transform
	
	var area_shape_owner_id = shape_find_owner(local_shape_index)
	var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
	var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
	var area_global_transform = area_shape_owner.global_transform
	
	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform,
									body_shape_2d,
									body_global_transform)
	print(collision_points)
