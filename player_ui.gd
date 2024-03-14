extends CanvasLayer 

class_name PlayerUI

#--------------------------------------------------------------------------------------------------
@onready var healthscore = $MarginContainer/HealthScore
@onready var score = $MarginContainer/EnemyScore
#--------------------------------------------------------------------------------------------------

var curr_score : int = 0
var num

func _ready():
	num = EventBus.enemy_died.connect(_on_enemy_died)

func set_health(max_value: int):
	healthscore.text = str("Health: ", max_value)

func set_score(value: int):
	score.text = str("Score: ", value)

func _on_enemy_died(value):
	curr_score += value
	set_score(curr_score)

