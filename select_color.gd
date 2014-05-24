extends Node2D

var colors = ["green", "red", "yellow", "blue", "purple", "teal", "orange", "pink"]
var anims = {}
var global = null

var _2players = false

var last = { "p1" : 0, "p2" : 1 }
var current = { "p1" : 0, "p2" : 1 }
var selected = { "p1" : "", "p2" : "" }

func _ready():
	global = get_node("/root/global")

	if global.status == global.SELECT2P:
		_2players = true
		get_node("p2").show()

	for child in get_node("colors").get_children():
		var color = child.get_name()
		var anim_path = "colors/" + color + "/tank/anim"
		var anim_node = get_node(anim_path)
		anim_node.play(color)

		# also save them for later: anims initalization
		anims[color] = anim_node

	# set_currents needs anims to be initializaded, so it goes at the end of _ready
	set_currents()
	set_process_input(true)

func set_currents():
	set_current("p1")
	if _2players:
		set_current("p2")

func set_current(player):

	var color = colors[current[player]]
	var last_color = colors[last[player]]
	var tank_pos = get_node("colors/" + color).get_pos()
	get_node(player).set_pos(Vector2(tank_pos.x, tank_pos.y + 50))
	anims[color].set_speed(1)
	anims[color].seek(0, true)
	anims[color].play("rotate "+color)

	if last[player] != current[player]:
		var blendt = anims[last_color].get_current_animation_length() - anims[last_color].get_current_animation_pos()
		anims[last_color].set_blend_time("rotate "+last_color, last_color, blendt)
		anims[last_color].set_speed(7)
		anims[last_color].play(last_color)

	last[player] = current[player]

func _input(ev):

	if ev.is_action("ui_cancel"):
		global.goto_scene("res://title.xml")

	process_input(ev, "p1")
	if _2players:
		process_input(ev, "p2")

	if selected["p1"] != "" and (!_2players or selected["p2"] != ""):
		global.status = global.PLAYING
		global.goto_scene("res://map1.xml")

func process_input(ev, player):

	#keys pressed
	var up = ev.is_action(player + "up")
	var down = ev.is_action(player + "down")
	var left = ev.is_action(player + "left")
	var right = ev.is_action(player + "right")
	var shoot = ev.is_action(player + "shoot")

	if ev.is_pressed():
		if up or down:
			current[player] += 4
		elif right:
			current[player] += 1
		elif left:
			current[player] -= 1
		elif shoot:
			selected[player] = colors[current[player]]

		if current[player] > colors.size() - 1:
			current[player] = current[player] % (colors.size())
		elif current[player] < 0:
			current[player] = colors.size() - 1

		if last[player] != current[player]:
			set_current(player)
