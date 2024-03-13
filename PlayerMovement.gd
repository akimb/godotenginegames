extends CharacterBody2D

class_name Player

#--------------------------------------------------------------------------------------------------
@export var speed = 150  # speed in pixels/sec
@export var rotation_speed = 10
@export var health : int = 10
@export var playerui : PlayerUI
@export var playerdamage : int = 1
#--------------------------------------------------------------------------------------------------
var Bullet = load("res://Bullet.tscn") 
var score : int = 0
var angle
var deathscreen : PackedScene = load("res://deathscreen.tscn")
var isHealth : bool = false
var maxHealth = health
#--------------------------------------------------------------------------------------------------
@onready var laser = $"../Sounds/lasergun"
@onready var bite = $"../Sounds/zombiebite"
@onready var playerdeath = $"../Sounds/playerdeath"
@onready var playerhurt = $"../Sounds/playerhurt"
#--------------------------------------------------------------------------------------------------

signal interacted

func _ready():
	playerui.set_health(health)

func _process(delta):
#	_on_enemy_died()
#	inZone()
	pass

func _input(event):
	angle = (get_global_mouse_position() - global_position).angle()
	
	if Input.is_action_just_pressed("dash"):
		dash()

	if Input.is_action_just_pressed("shoot"):
		shoot()
		
#	if Input.is_action_just_pressed("interact"):
#		emit_signal("interacted")

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized()
	velocity = direction * speed

	move_and_slide()
	
	if angle:
		global_rotation = lerp_angle(global_rotation, angle, delta * rotation_speed)

func shoot():
	var b = Bullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = $Muzzle.global_transform
	laser.play()

func dash():
	print("dash")
	#using timer, make player move 2x as fast for like 0.1 seconds
	#using timer, teleport player a set distance 
	
func _on_hitbox_area_entered(area):
	if area.is_in_group("mobs"):
		health -= 1 #change later for different enemy damage types
		playerhurt.play()
		
		if health >= 0:
			playerui.set_health(health)

		if health == 0:
			playerdeath.play()
			get_tree().root.add_child(deathscreen.instantiate())
			disable_player()
			reset_score()
			
	elif area.is_in_group("health"):
		if health < maxHealth:
			health += 1
			playerui.set_health(health)
			

func disable_player():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	
func reset_score():
	EventBus.score = 0
