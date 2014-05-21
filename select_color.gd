
extends Node2D

var colors = ["green", "red", "yellow", "blue", "purple", "teal", "orange", "pink"]
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
	anims[color].set_speed(1)
	anims[color].seek(0, true)
	anims[color].play("rotate "+color)

	if last != current:
		var blendt = anims[last_color].get_current_animation_length() - anims[last_color].get_current_animation_pos()
		anims[last_color].set_blend_time("rotate "+last_color, last_color, blendt)
		anims[last_color].set_speed(7)
		anims[last_color].play(last_color)

	last = current


func _input(ev):
	if ev.is_pressed():
		if ev.is_action("ui_up") or ev.is_action("ui_down"):
			current += 4
		elif ev.is_action("ui_right"):
			current += 1
		elif ev.is_action("ui_left"):
			current -= 1
		elif ev.is_action("ui_accept"):
			get_node("/root/global").goto_scene("res://map1.xml")
		elif ev.is_action("ui_cancel"):
			get_node("/root/global").goto_scene("res://title.xml")


		if current > colors.size() - 1:
			current = current % (colors.size() )
		elif current < 0:
			current = colors.size() - 1

		if last != current:
			set_current()
