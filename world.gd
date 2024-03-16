extends Node2D

class_name WorldManager

#--------------------------------------------------------------------------------------------------
@export var enemy_scenes : Array[PackedScene] = []
#------------------------------------------------------------------------------s--------------------
@onready var parasitelooped = $Sounds/parasitelooped
@onready var player = $Player
#--------------------------------------------------------------------------------------------------
#var enemypreload = preload("res://collision_test_zombie.tscn")
var rect_min = Vector2(-576, -324)
var rect_max = Vector2(576, 324)
#--------------------------------------------------------------------------------------------------

func _ready():
#	parasitelooped.play()
#	$"Interactable Test".connect("isInZone",inZone)
	pass
	
func _process(delta):
	inZone()

func _on_spawn_enemies_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.position = generatecoords() + player.position
	add_child(enemy)
	
func generatecoords() -> Vector2:
	var random_coords = Vector2.ZERO

	# Generate random coordinates
	random_coords = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
	return random_coords

func inZone():
	if Input.is_action_just_pressed("interact"):
		print("signal connected")
		
func _on_parasitebuild_finished():
	parasitelooped.play()

## BELOW IS A POSSIBLE CODE FIX FOR ENEMIES SPAWNING INSIDE PHYSICS LAYERSaa

#extends Node2D
#
#onready var zombie = preload("res://Zombie.tscn")
#onready var zContainer = get_node("zContainer")
#
#onready var tilemap = $TileMap
#
#var screensize
#var zCount = 0
#var level = 1
#var valid_cells
#
#func _ready():
#	randomize()
#	set_process(true)
#	screensize = get_viewport().get_visible_rect().size
#	get_valid_cells() # Compute the valid cells in the tilemap
#	spawn_zombies(50)
#
#func get_valid_cells() -> void:
#	valid_cells = []
#	for cell in tilemap.get_used_cells():
#		if tilemap.get_cellv(cell) != 3:	# 3 == wall
#			valid_cells.append(cell)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	zCount = zContainer.get_child_count()
#	# print("zCount ",zCount, "   Level: ",level)
#	$HUD/Label.set_text(str(zCount))
#	if zContainer.get_child_count() == 0:
#		level += 1
#		spawn_zombies(level * 1)
#
#func spawn_zombies(num):
#	var cells_to_use = valid_cells.duplicate() # Copy the cells
#	cells_to_use.shuffle()  # Randomly shuffle them
#	var cell_size = tilemap.cell_size
#	for _i in range(num):
#		var z = zombie.instance()
#		z.add_to_group("zombies")
#		get_tree().call_group("zombies", "set_player", $Player)
#		z.set_position(cells_to_use.pop_front() * cell_size + cell_size/2.0)
#		zContainer.add_child(z)


