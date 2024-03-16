extends CharacterBody2D

class_name Enemy

#--------------------------------------------------------------------------------------------------
@export var speed = 100
@export var health = 5
@export var zombie_damage = 1
@export var zombieScoreVal = 1
@export var isHealthEnemy : bool = false
@export var isDebuffEnemy : bool = false
@export var isBuffEnemy: bool = false
#@export var healthbar : HealthBar
#@export var enemyui = ProgressBar
#@export var playerui : PlayerUI
#--------------------------------------------------------------------------------------------------
@onready var player = $"../Player"
#@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var zombiebite = $"../Sounds/zombiebite"
@onready var zombiehurt = $"../Sounds/zombiehurt"
@onready var zombiedeath = $"../Sounds/zombiedeath"
@onready var zombiehealthdebug = $zombiehealthdebug
@onready var healthpickup = $"../Sounds/healthpickup"
@onready var healthbar = $HealthBar
@onready var googlyEyes = $GooglyEyes
@onready var enemysprite = $"Enemy Sprite"
#--------------------------------------------------------------------------------------------------
#var angle
#var can_contact : bool = false
var playerDamage := 0
#--------------------------------------------------------------------------------------------------

func _ready():
#	enemyui.set_health(health)
	zombiehealthdebug.text = str(health)
	healthbar.init_health(health)
	EventBus.goofymode.connect(goofyEnabled)
	EventBus.playerDamage.connect(damageValue)
	
#func _process(delta):
#	EventBus.goofymode.connect(goofyEnabled)
	
func _physics_process(delta):
	
	velocity = Vector2.ZERO
	velocity = (player.position - position).normalized() * speed

	if isHealthEnemy or isBuffEnemy:
		velocity = -position.direction_to(player.position) * speed
#		rotation = velocity.angle()
	else:
		velocity = position.direction_to(player.position) * speed
#		rotation = -velocity.angle()

	move_and_collide(velocity * delta)
#	var dir = to_local(nav_agent.get_next_path_position()).normalized()
#	if isHealthEnemy:
#		dir = -dir
#	velocity = dir * speed
#	move_and_slide()
	

#func makepath() -> void:
#	nav_agent.target_position = player.global_position
func _on_nav_timer_timeout():
#	makepath()
	pass

func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		zombiehurt.play()
		health -= playerDamage
		sprite_flash()
		healthbar.health = health
		zombiehealthdebug.text = str(health)
		
		if health <= 0:
			zombiedeath.play()
			EventBus.enemy_died.emit(self.zombieScoreVal)
			queue_free()
			
	if area.is_in_group("player") and not isHealthEnemy:
		EventBus.enemyAttack.emit(self.zombie_damage)
		zombiebite.play()

	if area.is_in_group("player") and isHealthEnemy:
		healthpickup.play()
		queue_free()
	
	if area.is_in_group("player") and (isDebuffEnemy or isBuffEnemy):
		queue_free()
		
func goofyEnabled(isGoofy):
	if isGoofy:
		googlyEyes.show()
	else:
		googlyEyes.hide()
		

func damageValue(value):
	playerDamage = value

func sprite_flash() -> void:
	enemysprite.modulate = Color.RED
	await get_tree().create_timer(0.08).timeout
	enemysprite.modulate = Color.WHITE
#	var tween: Tween = create_tween()
#	tween.tween_property(enemysprite, "modulate:v", 1, 0.25).from(15)
#	tween.tween_property(enemysprite, "modulate:v", Color.RED, 0.25).from(15)

#func _on_can_attack_timeout():
#	EventBus.canAttack.emit(zombie_damage)
