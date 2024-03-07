extends CharacterBody2D

class_name Player
#const laser_sfx = preload("res://blaster-2-81267.mp3")
@export var speed = 300  # speed in pixels/sec
@export var rotation_speed = 10
var Bullet = load("res://Bullet.tscn") 
#const shootsfx = preload("res://blaster-2-81267.mp3")

@onready var laser = $"../lasergun"

var angle

func _input(event):
	angle = (get_global_mouse_position() - global_position).angle()
	
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
