extends CanvasLayer 

class_name PlayerUI

#--------------------------------------------------------------------------------------------------
@onready var healthscore = $MarginContainer/HealthScore
@onready var score = $MarginContainer/EnemyScore
@onready var levelup = $"MarginContainer/LevelUp"
@onready var boss = $MarginContainer/Boss
@onready var leveluptimer = $LevelUpTimerUI
@onready var bosswarning = $BossWarningTimerUI
#--------------------------------------------------------------------------------------------------

var curr_score : int = 0
var num

func _ready():
	num = EventBus.enemy_died.connect(_on_enemy_died)
	EventBus.levelUp.connect(_on_level_up)
	EventBus.bossLevel.connect(_show_boss_warning)

func set_health(max_value: int):
	healthscore.text = str("Health: ", max_value)

func set_score(value: int):
	score.text = str("Score: ", value)

func _on_enemy_died(value):
	curr_score += value
	set_score(curr_score)

func _on_level_up():
	leveluptimer.start()
	levelup.show()

func _on_level_up_timer_ui_timeout():
	levelup.hide()

func _show_boss_warning():
	bosswarning.start()
	boss.show()

func _on_boss_warning_timer_ui_timeout():
	boss.hide()
