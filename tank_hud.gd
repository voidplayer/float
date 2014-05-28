extends Control
export var hudid = ""
export var lives = 3

func _ready():
	# Initalization here
	pass

func set_lives(liv):
	lives = liv
	get_node("lives").set_text(str(lives))

func set_color(color):
	var anim = get_node("tank/tank/anim")
	assert anim
	anim.play(color)