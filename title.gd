extends Control


const PREMENU = 0
const MENU = 1
const NETWORK = 2
const CREDITS = 3

var status = PREMENU

var menu = [ "menu", "1player", "2players", "network", "credits" ]
var network = [ "network", "server", "client", "back" ]
var credits = [ "credits", "back" ]

var selector = 1
var selector_tank
var selector_anim

var global = null

func _ready():
	set_process_input(true)
	selector_tank = get_node("selector")
	selector_anim = selector_tank.get_node("Sprite/anim")
	global = get_node("/root/global")
	global.reset()
	thegreat_play()

func thegreat_play():
	var letters = [ "t", "h", "e", "g", "r", "e2", "a", "t2" ]
	for letter in letters:
		get_node("thegreat/" + letter + "/anim").play("enter")

func action_menu(action):
	var thismenu = menu
	if status == NETWORK:
		thismenu = network
	elif status == CREDITS:
		thismenu = credits

	if action == "down":
		if selector == thismenu.size()-1:
			selector = 1
		else:
			selector += 1
	elif (action == "up"):
		if selector == 1:
			selector = thismenu.size()-1
		else:
			selector -= 1
	elif action == "select":
		selector_anim.play("selected")
		selector_anim.queue("enter")
		selector = 1
	else:
		print("BUG: menu action not implemented")

	var itempos = get_node(thismenu[0] + "/" + thismenu[selector]).get_pos()
	selector_tank.set_pos(Vector2(itempos.x - 30, itempos.y))

func _input(ev):
	if ev.is_pressed():
		if ev.is_action("ui_cancel"):
			get_scene().quit()

		if status == PREMENU:
			if ev.is_action("ui_accept"):
				get_node("enter").hide()
				get_node("menu").show()
				selector_tank.show()
				selector_anim.play("enter")
				status = MENU
		elif status == MENU:
			if ev.is_action("ui_down"):
				action_menu("down")
			elif ev.is_action("ui_up"):
				action_menu("up")
			elif ev.is_action("ui_accept"):
				#1 player selected
				if selector == 1:
					global.status = global.SELECT1P
					global.goto_scene("res://select_color.xml")
				#2 players selected
				elif selector == 2:
					global.status = global.SELECT2P
					global.goto_scene("res://select_color.xml")
				#network selected
				elif selector == 3:
					get_node("menu").hide()
					get_node("network").show()
					status = NETWORK
				#credits selected
				elif selector == 4:
					get_node("menu").hide()
					get_node("credits").show()
					status = CREDITS
				action_menu("select")
		elif status == NETWORK:
			if ev.is_action("ui_down"):
				action_menu("down")
			elif ev.is_action("ui_up"):
				action_menu("up")
			elif ev.is_action("ui_accept"):
				#server selected
				if selector == 1: 
					global.create_server()
					global.status = global.SERVER
					global.goto_scene("res://network.xml")
				#client selected
				elif selector == 2:
					global.connect_to_server()
					global.status = global.CLIENT
					global.goto_scene("res://network.xml")
				#back selected
				elif selector == 3:
					action_menu("select")
					get_node("network").hide()
					get_node("menu").show()
					status = MENU
				action_menu("select")
		elif status == CREDITS:
			if ev.is_action("ui_accept"):
				get_node("credits").hide()
				get_node("menu").show()
				status = MENU
				action_menu("select")
		else:
			print("BUG: tittle status not registered yet")
