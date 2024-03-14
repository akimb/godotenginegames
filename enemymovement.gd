extends CharacterBody2D

class_name Enemy

#var playerImpact : Player
#--------------------------------------------------------------------------------------------------
@export var speed = 100
@export var health = 5
@export var zombie_damage = 1
@export var zombieScoreVal = 1
@export var isHealthEnemy : bool = false
@export var isDebuffEnemy : bool = false
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
#--------------------------------------------------------------------------------------------------
#var angle
#var can_contact : bool = false
#--------------------------------------------------------------------------------------------------

func _ready():
#	enemyui.set_health(health)
	zombiehealthdebug.text = str(health)
	healthbar.init_health(health)

	
func _physics_process(delta):
#	var dir = to_local(nav_agent.get_next_path_position()).normalized()
#	if isHealthEnemy:
#		dir = -dir
#	velocity = dir * speed
#	move_and_slide()
	

#func makepath() -> void:
#	nav_agent.target_position = player.global_position
	
	velocity = Vector2.ZERO
	velocity = (player.position - position).normalized() * speed

	if not isHealthEnemy:
		velocity = position.direction_to(player.position) * speed
#		rotation = velocity.angle()
	else:
		velocity = -position.direction_to(player.position) * speed
#		rotation = -velocity.angle()

	var collide = move_and_collide(velocity * delta)

func _on_nav_timer_timeout():
#	makepath()
	pass

func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		zombiehurt.play()
		health -= EventBus.playerDamage
		healthbar.health = health
#		enemyui.set_health(health)
		zombiehealthdebug.text = str(health)
		
		if health <= 0:
#			enemyui.set_health(health)
			zombiedeath.play()
			EventBus.enemy_died.emit(self.zombieScoreVal)
#			EventBus.isHealthEnemy.emit(self.isHealthEnemy)
			queue_free()
			
	if area.is_in_group("player") and not isHealthEnemy:
		zombiebite.play()

	if area.is_in_group("player") and isHealthEnemy:
		healthpickup.play()
		queue_free()
	
	if area.is_in_group("player") and isDebuffEnemy:
		queue_free()
		

#func get_score(value) -> int:
#	return value

