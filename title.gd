extends Control


const PREMENU = 0
const MENU = 1

var status = PREMENU

var menu1 = [ "1player", "2players", "network", "credits" ]

var selector = 0
var selector_tank = null

func _ready():
	set_process_input(true)
	selector_tank = get_node("menu/selector")

func action_menu(action, menu):
	print (menu.size())
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
		pass
	else:
		print("BUG: menu action not implemented")

	selector_tank.set_pos(get_node("menu/"+menu1[selector]).get_pos())

func _input(ev):
	if status == PREMENU:
		if (ev.is_action("ui_accept") and ev.is_pressed()):
			get_node("enter").hide()
			get_node("menu").show()
			selector = 0
			status = MENU
	elif status == MENU:
		if (ev.is_action("ui_down") and ev.is_pressed()):
			action_menu("down", menu1)
		elif (ev.is_action("ui_up") and ev.is_pressed()):
			action_menu("up", menu1)

	else:
		print("BUG: tittle status not registered yet")