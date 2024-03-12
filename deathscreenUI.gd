extends CanvasLayer

class_name deathScreenUI 

#--------------------------------------------------------------------------------------------------
@onready var highscore = $MarginContainer/highscore
#--------------------------------------------------------------------------------------------------
var titlescreen : PackedScene = load("res://title_screen.tscn")
#--------------------------------------------------------------------------------------------------

func _ready():
	set_final_score(EventBus.score)

func set_final_score(max_value: int):

	highscore.text = str("You Died!\nScore: ", max_value)


func _on_reset_pressed():
	get_tree().change_scene_to_packed(titlescreen)
	get_tree().root.remove_child(self)
