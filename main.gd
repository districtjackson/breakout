extends Node2D

@export var simulation_tps = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.set_physics_ticks_per_second(simulation_tps)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
