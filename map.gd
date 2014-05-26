extends Node2D


var global = null

func _ready():
	global = get_node("/root/global")
	var map = load(global.current_map)
	var mi = map.instance()
	add_child(mi)
	move_child(mi, 0)
	
	for pid in global.players:
		add_tank(pid)

func add_tank(pid):
	var tank = preload("res://tank.xml")
	var ti = tank.instance()
	ti.tankid = pid
	ti.tankcolor = global.colors[pid]
	ti.set_pos(get_node("map1/spawn/"+pid).get_pos())
	add_child(ti)

