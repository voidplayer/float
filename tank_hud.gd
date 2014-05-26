extends Control

export var hudid = ""

func _ready():
	# Initalization here
	pass

func set_lives(lives):
	get_node("lives").set_text(str(lives))

func set_color(color):
	var anim = get_node("Control/tank/anim")
	assert anim
	anim.play(color)