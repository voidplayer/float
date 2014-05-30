extends CanvasLayer

var hud = {}
var tank_hud = null
var global = null
var pause = false

func _ready():
	tank_hud = preload("res://tank_hud.xml")
	global = get_node("/root/global")

	for player in global.players:
		add_hudtank(player, global.colors[player] )

	set_process_input(true)


func _input(ev):
	if ev.is_pressed():
		if ev.is_action("ui_cancel"):
			if global.status == global.GAMEOVER:
				get_scene().set_pause(false)
			global.goto_scene("res://title.xml")
		elif ev.is_action("pause") and global.status == global.PLAYING:
			pause = !pause
			if pause:
				get_scene().set_pause(true)
				get_node("pause").show()
			else:
				get_scene().set_pause(false)
				get_node("pause").hide()

func add_hudtank(hudid, color):
	var ti = tank_hud.instance()
	ti.hudid = hudid
	ti.set_color(color)
	get_node("HBoxContainer").add_child(ti)
	hud[hudid] = ti

func set_lives(hudid, lives):
	hud[hudid].set_lives(lives)
	if lives == 0:
		check_victory()

func check_victory():
	var alive = 0
	var winner = ""

	for player in hud:
		if hud[player].lives > 0:
			alive += 1
			winner = hud[player]
	if alive == 1:
		get_node("victory").add_child(winner.get_node("tank/tank").duplicate())
		get_node("victory").set_text(" wins!")
		get_node("victory/anim").play("victory")
		global.status = global.GAMEOVER
		get_scene().set_pause(true)