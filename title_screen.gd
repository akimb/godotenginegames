extends Control

#--------------------------------------------------------------------------------------------------
var mainscene : PackedScene = load("res://main.tscn")
#--------------------------------------------------------------------------------------------------

func _on_button_pressed():
	get_tree().change_scene_to_packed(mainscene)

func _on_quit_pressed():
	get_tree().quit()

