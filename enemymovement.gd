extends CharacterBody2D

class_name Enemy

#var playerImpact : Player
#--------------------------------------------------------------------------------------------------
@export var speed = 300
@export var health = 5
@export var zombie_damage = 1
@export var zombieScoreVal = 1
#@export var playerui : PlayerUI
#--------------------------------------------------------------------------------------------------
@onready var player = $"../Player"
@onready var zombiebite = $"../Sounds/zombiebite"
@onready var zombiehurt = $"../Sounds/zombiehurt"
@onready var zombiedeath = $"../Sounds/zombiedeath"
@onready var zombiehealthdebug = $zombiehealthdebug
#--------------------------------------------------------------------------------------------------
var angle
var can_contact : bool = false
#--------------------------------------------------------------------------------------------------
#signal enemy_died(value)
#--------------------------------------------------------------------------------------------------

func _ready():
	zombiehealthdebug.text = str(health)

func _physics_process(delta):
	velocity = Vector2.ZERO
	velocity = (player.position - position).normalized() * speed
	velocity = position.direction_to(player.position) * speed

	rotation = velocity.angle()
	var collide = move_and_collide(velocity * delta)

func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		zombiehurt.play()
		health -= 1
		zombiehealthdebug.text = str(health)
		if health == 0:
			zombiedeath.play()
			EventBus.enemy_died.emit(self.zombieScoreVal)
			queue_free()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		zombiebite.play()
	elif body.is_in_group("mobs"):
		pass

func get_score(value) -> int:
	return value
