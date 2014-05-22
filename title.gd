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
	#action_menu(menu, "enter_menu")

func action_menu(action):
	var thismenu = menu
	if status == NETWORK:
		thismenu = network
	elif status == CREDITS:
		thismenu = credits
	#if action == "enter_menu":
	#	selector = 1
	#else:
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
				if menu[selector] == menu[1]:
					global.goto_scene("res://select_color.xml")
					global.status = global.SELECT1P
				elif menu[selector] == menu[2]:
					global.goto_scene("res://select_color.xml")
					global.status = global.SELECT2P
				elif menu[selector] == menu[3]:
					get_node("menu").hide()
					get_node("network").show()
					status = NETWORK
				elif menu[selector] == menu[4]:
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
				if network[selector] == network[1]:
					pass
				elif network[selector] == menu[2]:
					pass
				elif menu[selector] == menu[3]:
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
