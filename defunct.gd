extends CharacterBody2D

#class_name Player
#const laser_sfx = preload("res://blaster-2-81267.mp3")
@export var speed = 30  # speed in pixels/sec
@export var rotation_speed = 10
@export var health : int = 10
@export var health_ui : PlayerUI
@export var player_damage : int = 1
#@export var zombie : Enemy
#@export var health_score : Label
var Bullet = load("res://Bullet.tscn") 
var enemy : Enemy
#const shootsfx = preload("res://blaster-2-81267.mp3")

@onready var laser = $"../Sounds/lasergun"
@onready var bite = $"../Sounds/zombiebite"
@onready var playerdeath = $"../Sounds/playerdeath"
@onready var playerhurt = $"../Sounds/playerhurt"

var angle

func _ready():
	health_ui.set_health(health)

func _input(event):
	angle = (get_global_mouse_position() - global_position).angle()
	
	if Input.is_action_just_pressed("dash"):
		dash()

	if Input.is_action_just_pressed("shoot"):
		shoot()

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
	health -= 1
#	health -= enemy.zombiedamsage
	var dmg = enemy.get_dmg()
	print(dmg)
	playerhurt.play()
	
	if health >= 0:
		health_ui.set_health(health)

	if health == 0:
		playerdeath.play()

