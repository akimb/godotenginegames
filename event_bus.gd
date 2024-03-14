extends Node

## Signal Bus to handle global signal values
#--------------------------------------------------------------------------------------------------
signal enemy_died(enemy)
signal isHealthEnemy(enemy)
signal rapidfirestarts
signal rapidfireends

var score : int = 0
var playerDamage : int = 1

func _ready():
	print("loaded eventbus")
	
