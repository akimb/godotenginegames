extends Node2D

class_name WorldManager

#--------------------------------------------------------------------------------------------------
@export var enemy_scenes : Array[PackedScene] = []
@export var spawn_enemy_time_difference := 0.2
@export var boss_enemy = load("res://boss_enemy.tscn")
#------------------------------------------------------------------------------s--------------------
@onready var health_enemy : PackedScene = load("res://health_enemy.tscn")
@onready var hard_enemy : PackedScene = load("res://hard_enemy.tscn")
@onready var buff_enemy : PackedScene = load("res://buff_enemy.tscn")
@onready var debuff_enemy : PackedScene = load("res://debuff_enemy.tscn")
#------------------------------------------------------------------------------s--------------------
@onready var parasitelooped = $Sounds/parasitelooped
@onready var goofyahhhbeat = $Sounds/goofyahhhbeat
@onready var bossroar = $Sounds/bossroar
@onready var player = $Player
@onready var tilemap = $TileMap
@onready var spawnenemytime = $SpawnEnemies
#--------------------------------------------------------------------------------------------------
#var enemypreload = preload("res://collision_test_zombie.tscn")
var rect_min = Vector2(-79, -42)
var rect_max = Vector2(75, 63)
var valid_cells
var max_difficulty_time = 0.24
var isGoofy := false
#--------------------------------------------------------------------------------------------------

func _ready():
#	$"Interactable Test".connect("isInZone",inZone)
	randomize()
#	get_valid_cells()
	
func _process(_delta):
#	if Input.is_action_pressed("goofy") or isGoofy == true:
#		isGoofy = true
#		EventBus.goofymode.emit(self.isGoofy)
#		parasitelooped.play()
#
#	if Input.is_action_pressed("regular") or isGoofy == false:
#		isGoofy = false
#		EventBus.goofymode.emit(self.isGoofy)
#		goofyahhhbeat.play()
	pass

func _input(_event):
	if Input.is_action_pressed("goofy"):
		isGoofy = true
		EventBus.goofymode.emit(self.isGoofy)
		goofyahhhbeat.play()
		parasitelooped.stop()
		
	if Input.is_action_pressed("regular"):
		isGoofy = false
		EventBus.goofymode.emit(self.isGoofy)
		parasitelooped.play()
		goofyahhhbeat.stop()

func get_valid_cells() -> void:
	valid_cells = []
	for cell in tilemap.get_used_cells(0):
		if tilemap.get_cell_source_id(0, cell) != 1:	# 3 == wall
			valid_cells.append(cell)
			
func _on_spawn_enemies_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.position = generatecoords() + player.global_position
	add_child(enemy)
#	var cells_to_use = valid_cells.duplicate()
#	cells_to_use.shuffle()
#	var cell_size = tilemap.cell_quadrant_size
##	print(valid_cells)
#	var newPosition = Vector2(cells_to_use.pop_front().x * cell_size + cell_size/2.0, cells_to_use.pop_front().y * cell_size + cell_size/2.0)
#	print(newPosition)
#	print(player.position)
#	enemy.set_position(newPosition)
#	add_child(enemy)

func _on_spawn_boss_timeout():
	EventBus.bossLevel.emit()
	var boss = boss_enemy.instantiate()
	boss.position = generatecoords() + player.global_position
	add_child(boss)
	bossroar.play()

func generatecoords() -> Vector2:
	var random_coords = Vector2.ZERO

	# Generate random coordinates
	random_coords = Vector2(randf_range(-500, 500), randf_range(-500, 500))
	return random_coords

#func inZone():
#	if Input.is_action_just_pressed("interact"):
#		print("signal connected")
		
func _on_parasitebuild_finished():
	parasitelooped.play()


func _on_difficulty_timer_timeout():
#	print("level up")
	EventBus.levelUp.emit()
	if spawnenemytime.wait_time > max_difficulty_time:
		enemy_scenes.append(health_enemy)
		enemy_scenes.append(hard_enemy)
		enemy_scenes.append(buff_enemy)
		enemy_scenes.append(debuff_enemy)
		spawnenemytime.wait_time -= spawn_enemy_time_difference
		
