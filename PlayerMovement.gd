extends CharacterBody2D

class_name Player

#--------------------------------------------------------------------------------------------------
@export var speed = 150  # speed in pixels/sec
@export var rotation_speed = 10
@export var health : int = 10
#@export var playerui : PlayerUI
@export var playerdamage : int = 1
@export var cooldownTimer : Timer
@export var normalFireDelay := 0.2
@export var rapidFireDelay := 0.02
@export var doubleDamageFireDelay := 0.4
@export var rapidFireTime := 5
@export var doubleDamageTime := 5
@export var disableFireTime := 5
@export var visionLostTime := 5

@onready var playerui = $PlayerUI
@onready var charactersprite = $"Character Sprite"
#--------------------------------------------------------------------------------------------------
@onready var laser = $"../Sounds/lasergun"
@onready var bite = $"../Sounds/zombiebite"
@onready var playerdeath = $"../Sounds/playerdeath"
@onready var playerhurt = $"../Sounds/playerhurt"
@onready var rapidfirepowerup = $"../Sounds/rapidfirepowerup"
@onready var weaponsdisabled = $"../Sounds/weaponsdisabled"
@onready var visionlost = $"../Sounds/visionlost"
@onready var doubleDamage = $"../Sounds/doubledamage"
@onready var googlyEyes = $GooglyEyes
@onready var hitbox = $Hitbox
@onready var backgroundlight = $"../CanvasModulate"

#--------------------------------------------------------------------------------------------------
@onready var fireDelayTimer = $FireDelayTimer
@onready var rapidFireTimer = $RapidFireTimer
@onready var disableTimer = $DisableTimer
@onready var darkenTimer = $DarkenTimer
@onready var doubleDamageTimer = $DoubleDamageTimer
@onready var bullet : PackedScene =  load("res://Bullet.tscn")

#--------------------------------------------------------------------------------------------------
#var Bullet = load("res://Bullet.tscn") 
var score := 0
var angle
var deathscreen : PackedScene = load("res://deathscreen.tscn")
var isHealth := false
var maxHealth = health
var fireDelay := normalFireDelay
var canTakeDamage := true
var damageTaken := 0
var isRapidFire := false
var isDoubleDamage := false
#--------------------------------------------------------------------------------------------------

signal interacted
#signal buffed

func _ready():
	playerui.set_health(health)
	EventBus.goofymode.connect(goofyEnabled)
	EventBus.playerDamage.connect(changeDamage)
	damageTaken = EventBus.enemyAttack.connect(attack)
	
func _process(_delta):
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		shoot()

func _input(_event):
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
	b.transform = $Muzzle.global_transform
	if isRapidFire:
			EventBus.rapidfire.emit(self.isRapidFire)
	elif isDoubleDamage:
		EventBus.doubledamage.emit(self.isDoubleDamage)
	else:
		isRapidFire = false
		isDoubleDamage = false
	EventBus.playerDamage.emit(self.playerdamage)
	laser.play()

func dash():
	print("dash")
	#using timer, make player move 2x as fast for like 0.1 seconds
	#using timer, teleport player a set distance 
	
func _on_hitbox_area_entered(area):
	if area.is_in_group("basic"):
		health -= damageTaken
		sprite_flash()
		lose_health()
	
	if area.is_in_group("hard"):
		health -= damageTaken
		sprite_flash()
		lose_health()
		
	if area.is_in_group("debuff"):
		var pick = randi_range(0,1)
		if pick == 0:
			disableInput(disableFireTime)
		else:
			darkenVision(visionLostTime)
	
	if area.is_in_group("health"):
#		EventBus.rapidfirestarts.emit()
		if health < maxHealth:
			health += 2
			playerui.set_health(health)
		if health >= maxHealth:
			health = maxHealth
			playerui.set_health(health)
	
	if area.is_in_group("buff"):
		var pick = randi_range(0,1)
		if pick == 0:
			applyRapidFire(rapidFireTime)
		else:
			applyDoubleDamage(doubleDamageTime)

func changeDamage(value):
	playerdamage = value

func applyRapidFire(time):
	doubleDamageTimer.stop()
	fireDelay = rapidFireDelay
	isRapidFire = true
#	EventBus.rapidfire.emit(self.isRapidFire)
	laser.volume_db = -35
	rapidfirepowerup.play()
	changeDamage(1)
	rapidFireTimer.start(time)

func _on_rapid_fire_timer_timeout():
	fireDelay = normalFireDelay
	laser.volume_db = -30.916
	isRapidFire = false
	changeDamage(1)

func applyDoubleDamage(time):
	rapidFireTimer.stop()
	fireDelay = doubleDamageFireDelay
	isDoubleDamage = true
	doubleDamage.play()
	changeDamage(4)
	doubleDamageTimer.start(time)
	
func _on_double_damage_timer_timeout():
	fireDelay = normalFireDelay
	isDoubleDamage = false
	changeDamage(1)

func disableInput(time):
	set_process_input(false)
	set_process(false)
	weaponsdisabled.play()
	disableTimer.start(time)
	
func _on_disable_timer_timeout():
	set_process_input(true)
	set_process(true)

func darkenVision(time):
	backgroundlight.color = Color(0,0,0,1)
	visionlost.play()
	darkenTimer.start(time)

func _on_darken_timer_timeout():
	backgroundlight.color = Color(.57,.57,.57,1)

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
		hitbox.queue_free()
		playerdeath.play()
		get_tree().root.add_child(deathscreen.instantiate())
		end_player()
		reset_score()

func goofyEnabled(isGoofy):
	if isGoofy:
		googlyEyes.show()
	else:
		googlyEyes.hide()

func attack(value):
	damageTaken = value
	
func sprite_flash() -> void:
	charactersprite.modulate = Color.RED
	await get_tree().create_timer(0.08).timeout
	charactersprite.modulate = Color.WHITE
