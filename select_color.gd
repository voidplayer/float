
extends Node2D

var colors = [ "green", "red", "yellow", "blue", "purple", "teal", "orange", "pink" ]
var anims = {}

var last = 0
var current = 0

func _ready():
	for child in get_node("colors").get_children():
		var color = child.get_name()
		var anim_path = "colors/" + color + "/tank/anim"
		var anim_node = get_node(anim_path)
		anim_node.play(color)

		# also save them for later: anims initalization
		anims[color] = anim_node

	# set_current needs anims to be initializaded
	set_current()
	set_process_input(true)


func set_current():
	var color = colors[current]
	var last_color = colors[last]
	var tank_pos = get_node("colors/" + color).get_pos()
	get_node("p1").set_pos(Vector2(tank_pos.x, tank_pos.y + 50))
	anims[color].play("rotate "+color)
	anims[last_color].stop()
	last = current


func _input(ev):
	if ev.is_pressed():
		if ev.is_action("ui_up"):
			pass
		elif ev.is_action("ui_down"):
			pass
		elif ev.is_action("ui_right"):
			current += 1
			set_current()
		elif ev.is_action("ui_left"):
			current -= 1
			set_current()
		elif ev.is_action("ui_accept"):
			pass
