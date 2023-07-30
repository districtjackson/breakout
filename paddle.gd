extends Area2D

@export var speed = 500

var paddle_length
var screen_size

var shrunken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	paddle_length = $CollisionShape2D.shape.size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # Paddle's movement vector
									
	if(Input.is_action_pressed("left")):
		velocity.x -= 1
	if(Input.is_action_pressed("right")):
		velocity.x += 1
				
	position += velocity * delta * speed
	position.x = clamp(position.x, 0 + paddle_length, screen_size.x - paddle_length)

# Shrinks paddle when ball hits ceiling (Ball -> Main -> Here), and unshrinks it when ball respawns and game ends
func change_size():
	if(shrunken):
		$CollisionShape2D.shape.size.x = 140
		$SmallSprite.hide()
		$LargeSprite.show()
		shrunken = false
	else:
		$CollisionShape2D.shape.size.x = 100
		$LargeSprite.hide()
		$SmallSprite.show()
		shrunken = true
