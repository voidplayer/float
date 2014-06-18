
extends Node

var anim
var cur
var next
var nextnext
var prev
var prevprev
var global
var maps = [1,2,3,4,5]
var textures = []
var current_map = 0

func _ready():
	set_process_input(true)
	anim = get_node("anim")
	anim.set_current_animation("next")
	cur = get_node("cur")
	next = get_node("next")
	nextnext = get_node("nextnext")
	prev = get_node("prev")
	prevprev = get_node("prevprev")
	global = get_node("/root/global")

	for i in maps:
		textures.append(load("res://assets/map"+str(i)+".png"))

#use negative values to substract. Dont substract more than maps.size
func add_current(value):
	return (current_map + value + maps.size()) % maps.size()

func select_next():
	anim.seek(0)
	update_textures()
	current_map = add_current(1)
	anim.play("next")

func select_prev():
	anim.seek(anim.get_current_animation_length())
	current_map = add_current(-1)
	update_textures()
	anim.play("next", 1, -1, true)

func update_textures():
	prevprev.set_texture(textures[add_current(-2)])
	prev.set_texture(textures[add_current(-1)])
	cur.set_texture(textures[current_map])
	next.set_texture(textures[add_current(1)])
	nextnext.set_texture(textures[add_current(2)])

func _input(ie):
	if ie.is_pressed() and !anim.is_playing():
		if ie.is_action("ui_cancel"):
			global.goto_scene("res://select_color.xml")
		elif ie.is_action("ui_left"):
			select_next()
		elif ie.is_action("ui_right"):
			select_prev()
		elif ie.is_action("ui_accept"):
			global.current_map = "res://map" + str(maps[current_map]) + ".xml"
			global.goto_scene("res://map.xml")

