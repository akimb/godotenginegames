extends Area2D

class_name Bullet
#--------------------------------------------------------------------------------------------------
@export var speed = 1000
#--------------------------------------------------------------------------------------------------
@onready var bulletDeathTimer = $BulletDeathTimer
@onready var bulletSprite = $Sprite2D
#--------------------------------------------------------------------------------------------------

func _ready():
	bulletDeathTimer.start()
#	EventBus.rapidfirestarts.connect(changeColortoBlue)
#	EventBus.rapidfireends.connect(changeColorBack)
	
func _physics_process(delta):
	position += transform.x * speed * delta
#	EventBus.rapidfirestarts.connect(changeColortoBlue)
#	EventBus.rapidfireends.connect(changeColorBack)
#	bar = EventBus.isRapidFire.connect(changeColor)

func _on_bullet_death_timer_timeout():
	queue_free()

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	queue_free()

func changeColortoBlue():
	bulletSprite.modulate = Color(0,0,1)

func changeColorBack():
	bulletSprite.modulate = Color(0,0,0)



