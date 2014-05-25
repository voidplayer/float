extends CanvasLayer

var hud = {}
var tank_hud = null
var global = null

func _ready():
	tank_hud = preload("res://tank_hud.xml")
	global = get_node("/root/global")

	for player in global.players:
		add_hudtank(player, global.colors[player] )

func add_hudtank(hudid, color):
	var ti = tank_hud.instance()
	ti.hudid = hudid
	ti.set_color(color)
	get_node("HBoxContainer").add_child(ti)
	hud[hudid] = ti

func set_lives(hudid, lives):
	hud[hudid].set_lives(lives)
