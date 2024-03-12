extends Node2D

class_name WorldManager

#--------------------------------------------------------------------------------------------------
@export var enemy_scenes : Array[PackedScene] = []
#--------------------------------------------------------------------------------------------------
@onready var parasitelooped = $Sounds/parasitelooped
@onready var player = $Player
#--------------------------------------------------------------------------------------------------
#var enemypreload = preload("res://collision_test_zombie.tscn")
var rect_min = Vector2(-576, -324)
var rect_max = Vector2(576, 324)
#--------------------------------------------------------------------------------------------------

func _ready():
	parasitelooped.play()
	$"Interactable Test".connect("isInZone",inZone)
	
func _process(delta):
	inZone()

func _on_timer_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.position = generatecoords() + player.position
	add_child(enemy)
	pass
	
func generatecoords() -> Vector2:
	var random_coords = Vector2.ZERO

	# Generate random coordinates
	random_coords = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
	return random_coords

func inZone():
	if Input.is_action_just_pressed("interact"):
		print("signal connected")
		
