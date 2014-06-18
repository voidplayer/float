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

	#little hack so the scene works isolated
	global.reset()

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

func check_player_readiness():
	if !get_node("p1/anim").is_playing() and !get_node("p1/anim").is_playing():
		# global.status != global.PLAYING is to avoid a race condition because of buffer (or something) 
		if selected["p1"] != "" and (!_2players or selected["p2"] != "") and global.status != global.PLAYING:
			global.status = global.PLAYING
			global.add_player("p1")
			global.set_player_color("p1", selected["p1"])
			if selected["p2"] != "":
				global.add_player("p2")
				global.set_player_color("p2", selected["p2"])
			global.goto_scene("res://select_map.xml")

func _input(ev):

	if ev.is_action("ui_cancel"):
		global.goto_scene("res://title.xml")

	if selected["p1"] == "":
		process_input(ev, "p1")
	if _2players and selected["p2"] == "":
		process_input(ev, "p2")




func process_input(ev, player):

	#keys
	var up = ev.is_action(player + "up")
	var down = ev.is_action(player + "down")
	var left = ev.is_action(player + "left")
	var right = ev.is_action(player + "right")
	var shoot = ev.is_action(player + "shoot")


	if ev.is_pressed():
		var move = 0

		if up or down:
			move = 4
		elif right:
			move = 1
		elif left:
			move = -1
		elif shoot:
			selected[player] = colors[current[player]]
			get_node(player+"/anim").play("selected")

		# check to avoid moving to some used spot with more than one player
		if _2players:
			for pid in current:
				if pid != player and current[pid] == (current[player] + move) % (colors.size()):
					move *= 2

		current[player] += move

		if current[player] > colors.size() - 1:
			current[player] = current[player] % (colors.size())
		elif current[player] < 0:
			current[player] = colors.size() - 1

		if last[player] != current[player]:
			set_current(player)
