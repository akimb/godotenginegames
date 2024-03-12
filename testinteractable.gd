extends Area2D

class_name Interactable

@onready var pressE = $Interact

signal isInZone

func _ready():
	pressE.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		pressE.show()
		emit_signal("isInZone")
	
	else:
		pass
#	if Input.is_action_just_pressed("interact"):
#		printCheck.emit()
#		print("E pressed.")
#		$"../Player".interacted.connect("interacted",test())

func _on_area_exited(body):
	if body.is_in_group("player"):
		pressE.hide()

func test():
	print("Interacted")
