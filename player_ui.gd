extends CanvasLayer 

class_name HealthUI
@onready var healthscore = $MarginContainer/HealthScore

func set_health(max_value: int):
#	healthscore.max_value = max_value
	healthscore.text = str("Health: ", max_value)
#	print(healthscore)
	
#func update_health(life: int):
#	healthscore.value = life
#	print(healthscore.value)
##	set_health(healthscore.value)
