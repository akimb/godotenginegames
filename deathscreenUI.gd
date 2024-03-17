extends CanvasLayer

class_name deathScreenUI 

#--------------------------------------------------------------------------------------------------
@onready var highscore = $MarginContainer/highscore
#--------------------------------------------------------------------------------------------------
var titlescreen : PackedScene = load("res://title_screen.tscn")
#--------------------------------------------------------------------------------------------------

func _ready():
	EventBus.setDeathScore.connect(set_final_score)

func set_final_score(max_value):
	highscore.text = str("You Died!\nScore: ", max_value)

func _on_reset_pressed():
	get_tree().change_scene_to_packed(titlescreen)
	get_tree().root.remove_child(self)
