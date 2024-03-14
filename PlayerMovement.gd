extends CharacterBody2D

class_name Player

#--------------------------------------------------------------------------------------------------
@export var speed = 150  # speed in pixels/sec
@export var rotation_speed = 10
@export var health : int = 10
@export var playerui : PlayerUI
@export var playerdamage : int = 2
@export var cooldownTimer : Timer
@export var normalFireDelay := 0.2
@export var rapidFireDelay := 0.02
@export var rapidFireTime := 5
@export var disableFireTime := 3
#@export var bullet : Bullet
#--------------------------------------------------------------------------------------------------
@onready var laser = $"../Sounds/lasergun"
@onready var bite = $"../Sounds/zombiebite"
@onready var playerdeath = $"../Sounds/playerdeath"
@onready var playerhurt = $"../Sounds/playerhurt"
@onready var rapidfirepowerup = $"../Sounds/rapidfirepowerup"
@onready var weaponsdisabled = $"../Sounds/weaponsdisabled"

#--------------------------------------------------------------------------------------------------
@onready var fireDelayTimer = $FireDelayTimer
@onready var rapidFireTimer = $RapidFireTimer
@onready var disableTimer = $DisableTimer
@onready var bullet : PackedScene =  load("res://Bullet.tscn")

#--------------------------------------------------------------------------------------------------
#var Bullet = load("res://Bullet.tscn") 
var score : int = 0
var angle
var deathscreen : PackedScene = load("res://deathscreen.tscn")
var isHealth : bool = false
var maxHealth = health
var fireDelay := normalFireDelay
#--------------------------------------------------------------------------------------------------

signal interacted
#signal buffed

func _ready():
	playerui.set_health(health)

func _process(delta):

#	print(rapidFireTimer.time_left)
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		shoot()

func _input(event):
	if Input.is_action_just_pressed("dash"):
		dash()

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	angle = (get_global_mouse_position() - global_position).angle()
	direction = direction.normalized()
	velocity = direction * speed

	move_and_slide()
	
	if angle:
		global_rotation = lerp_angle(global_rotation, angle, delta * rotation_speed)

func shoot():
	var b = bullet.instantiate()
	get_tree().root.add_child(b)
	b.self_modulate = Color("blue")
	b.transform = $Muzzle.global_transform
	EventBus.playerDamage = 1
	laser.play()

func dash():
	print("dash")
	#using timer, make player move 2x as fast for like 0.1 seconds
	#using timer, teleport player a set distance 
	
func _on_hitbox_area_entered(area):
	if area.is_in_group("basic"):
		health -= 1
		lose_health()
	
	if area.is_in_group("hard"):
		health -= 3
		lose_health()
		
	if area.is_in_group("debuff"):
		# add a random picker for two functions
		disableInput(disableFireTime)
	
	if area.is_in_group("health"):
		applyRapidFire(rapidFireTime)
#		EventBus.rapidfirestarts.emit()
		if health < maxHealth:
			health += 2
			playerui.set_health(health)
		if health >= maxHealth:
			health = maxHealth
			playerui.set_health(health)


func applyRapidFire(time):
	fireDelay = rapidFireDelay
	rapidfirepowerup.play()
	EventBus.playerDamage = 2
#	EventBus.rapidfirestarts.emit()
	rapidFireTimer.start(time)
#	EventBus.rapidfirestarts.emit()
#	rapidFireTimer.start(time + rapidFireTimer.time_left)


func _on_rapid_fire_timer_timeout():
	fireDelay = normalFireDelay
#	EventBus.rapidfireends.emit()

func disableInput(time):
	set_process_input(false)
	set_process(false)
	weaponsdisabled.play()
	disableTimer.start(time)
	
func _on_disable_timer_timeout():
	set_process_input(true)
	set_process(true)

func end_player():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)

func reset_score():
	EventBus.score = 0
	
func lose_health():
	playerhurt.play()
	
	if health >= 0:
		playerui.set_health(health)

	if health <= 0:
		playerdeath.play()
		get_tree().root.add_child(deathscreen.instantiate())
		end_player()
		reset_score()
