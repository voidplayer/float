extends Control


const PREMENU = 0
const MENU = 1
const NETWORK = 2
const CREDITS = 3

var status = PREMENU

var menu1 = [ "1player", "2players", "network", "credits" ]
var network = [ "server", "client", "back" ]
var credits = [ "back", "back" ]

var selector = 0
var selector_tank = null

func _ready():
	print_tree()
	set_process_input(true)
	selector_tank = get_node("selector")
	action_menu(menu1, "enter_menu")

func action_menu(action, menu):

	if action == "enter_menu":
		selector = 0
	if action == "down":
		if selector == menu.size()-1:
			selector = 0
		else:
			selector += 1
	elif action == "up":
		if selector == 0:
			selector = menu.size()-1
		else:
			selector -= 1
	elif action == "select":
		selector_tank.get_node("TextureFrame/AnimationPlayer").play("selected")
	else:
		print("BUG: menu action not implemented")

	var itempos = get_node("menu/"+menu1[selector]).get_pos()
	selector_tank.set_pos(Vector2(itempos.x - 30, itempos.y))

func _input(ev):
	if ev.is_pressed():
		if status == PREMENU:
			if ev.is_action("ui_accept"):
				get_node("enter").hide()
				get_node("menu").show()
				selector_tank.show()
				status = MENU
		elif status == MENU:
			if ev.is_action("ui_down"):
				action_menu("down", menu1)
			elif ev.is_action("ui_up"):
				action_menu("up", menu1)
			elif ev.is_action("ui_accept"):
				action_menu("select", menu1)
				if menu1[selector] == menu1[0]:
					pass
				elif menu1[selector] == menu1[1]:
					pass
				elif menu1[selector] == menu1[2]:
					pass
				elif menu1[selector] == menu1[3]:
					get_node("menu").hide()
					get_node("credits").show()
					status = CREDITS
		elif status == CREDITS:
			if ev.is_action("ui_accept"):
				get_node("credits").hide()
				get_node("menu").show()
				status = MENU

		else:
			print("BUG: tittle status not registered yet")