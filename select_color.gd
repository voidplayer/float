extends Node2D

var colors = ["green", "red", "yellow", "blue", "purple", "teal", "orange", "pink"]
var anims = {}

var p1last = 0
var p1current = 0

func _ready():
	for child in get_node("colors").get_children():
		var color = child.get_name()
		var anim_path = "colors/" + color + "/tank/anim"
		var anim_node = get_node(anim_path)
		anim_node.play(color)

		# also save them for later: anims initalization
		anims[color] = anim_node

	# set_p1current needs anims to be initializaded
	set_current()
	set_process_input(true)


func set_current():

	var color = colors[p1current]
	var last_color = colors[p1last]
	var tank_pos = get_node("colors/" + color).get_pos()
	get_node("p1").set_pos(Vector2(tank_pos.x, tank_pos.y + 50))
	anims[color].set_speed(1)
	anims[color].seek(0, true)
	anims[color].play("rotate "+color)

	if p1last != p1current:
		var blendt = anims[last_color].get_current_animation_length() - anims[last_color].get_current_animation_pos()
		anims[last_color].set_blend_time("rotate "+last_color, last_color, blendt)
		anims[last_color].set_speed(7)
		anims[last_color].play(last_color)

	p1last = p1current


func _input(ev):

	if ev.is_action("ui_cancel"):
		get_node("/root/global").goto_scene("res://title.xml")

	#keys pressed
	var tank1up = ev.is_action("tank1up")
	var tank1down = ev.is_action("tank1down")
	var tank1left = ev.is_action("tank1left")
	var tank1right = ev.is_action("tank1right")
	var tank1shoot = ev.is_action("tank1shoot")
	
	var tank2up = ev.is_action("tank2up")
	var tank2down = ev.is_action("tank2down")
	var tank2left = ev.is_action("tank2left")
	var tank2right = ev.is_action("tank2right")
	var tank2shoot = ev.is_action("tank2shoot")
	

	if ev.is_pressed():
		#select p1
		if tank1up or tank1down:
			p1current += 4
		elif tank1right:
			p1current += 1
		elif tank1left:
			p1current -= 1
		elif tank1shoot:
			get_node("/root/global").goto_scene("res://map1.xml")
 
		#select p2
		if tank2up or tank2down:
			p1current += 4
		elif tank2right:
			p1current += 1
		elif tank2left:
			p1current -= 1
		elif tank2shoot:
			get_node("/root/global").goto_scene("res://map1.xml")

		if p1current > colors.size() - 1:
			p1current = p1current % (colors.size() )
		elif p1current < 0:
			p1current = colors.size() - 1

		if p1last != p1current:
			set_current()
