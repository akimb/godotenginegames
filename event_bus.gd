extends Node

## Signal Bus to handle global signal values
#--------------------------------------------------------------------------------------------------
signal enemy_died(enemy)
signal isHealthEnemy(enemy)
var score : int = 0

func _ready():
	print("loaded eventbus")
	
