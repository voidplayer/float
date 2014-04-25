
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _process(delta):
	if (Input.is_action_pressed("ui_cancel")):
		get_scene().quit()
		

func _ready():
	# Initalization here
	set_process(true)
	pass


