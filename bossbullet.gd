extends Area2D

class_name BossBullet
#--------------------------------------------------------------------------------------------------
@export var speed = 100
@export var bulletDamage = 2
#--------------------------------------------------------------------------------------------------
@onready var bulletDeathTimer = $BulletDeathTimer
@onready var bulletSprite = $"Bullet Sprite"
@onready var bulletLight = $"Bullet Light"
@onready var bulletParticles = $"Bullet Particles"
#--------------------------------------------------------------------------------------------------

var playerPos := Vector2.ZERO


func _ready():
	bulletDeathTimer.start()
	EventBus.bossBullet.emit(bulletDamage)
	EventBus.playerPosition.connect(getPlayerPosition)
	
func _physics_process(delta):
	var velocity = speed * delta

func _on_bullet_death_timer_timeout():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		queue_free()

func getPlayerPosition(pos):
	playerPos.x = pos.x
	playerPos.y = pos.y
	print(playerPos)
