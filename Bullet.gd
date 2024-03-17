extends Area2D

class_name Bullet
#--------------------------------------------------------------------------------------------------
@export var speed = 1000
#--------------------------------------------------------------------------------------------------
@onready var bulletDeathTimer = $BulletDeathTimer
@onready var bulletSprite = $"Bullet Sprite"
@onready var bulletLight = $"Bullet Light"
@onready var bulletParticles = $"Bullet Particles"
#@onready var laser = $"../Sounds/lasergun"
#--------------------------------------------------------------------------------------------------

func _ready():
	bulletDeathTimer.start()
	EventBus.rapidfire.connect(rapidFireBullet)
	EventBus.doubledamage.connect(doubleDamageBullet)
#	laser.play()
	
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_bullet_death_timer_timeout():
	queue_free()

func _on_area_entered(_area):
	queue_free()

func _on_body_entered(_body):
	queue_free()

func rapidFireBullet(switch):
	if switch:
		bulletSprite.modulate = Color.AQUA
		bulletLight.color = Color.AQUA
		bulletParticles.modulate = Color.AQUA
	else:
		bulletSprite.modulate = Color.WHITE
		bulletLight.color = Color(0.89,0,0.53,1)
		bulletParticles.modulate = Color.WHITE

func doubleDamageBullet(switch):
	if switch:
		bulletSprite.modulate = Color.ORANGE
		bulletLight.color = Color.ORANGE
		bulletParticles.modulate = Color.ORANGE
	else:
		bulletSprite.modulate = Color.WHITE
		bulletLight.color = Color(0.89,0,0.53,1)
		bulletParticles.modulate = Color.WHITE

