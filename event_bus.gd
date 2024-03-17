extends Node

## Signal Bus to handle global signal values
#--------------------------------------------------------------------------------------------------
signal enemy_died(enemy)
signal isHealthEnemy(enemy)
signal rapidfire
signal doubledamage
signal goofymode
signal enemyAttack(enemy)
signal levelUp
signal playerDamage
signal bossLevel
signal bossBullet
signal playerPosition
signal setDeathScore
signal currentScore

var score : int = 0
#var playerDamage : int = 1

func _ready():
	print("loaded eventbus")
	
