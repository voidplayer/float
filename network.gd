extends Control
var nick2 = ["Tea","Panda","Oak","Dragon","Mouse","Cookie"]

var global
var update = false

func _ready():
	global = get_node("/root/global")

	#debuggin only
	global.reset()
	#global.status = global.NETWORK
	
	#testing: if you cant connect, launch a server
	if global.connect_to_server():
		print("Connected to server succesfully")
		_ready_client()
	else:
		print("Unable to connect: creating server")
		_ready_server()
	set_process(true)


func _ready_server():
	global.create_server()

	var nick = nick2[0]
	global.add_player("p1")
	global.set_player_nick("p1", nick)
	get_node("nickedit").set_text(nick)
	
func _ready_client():
	var nick = nick2[1]
	get_node("play").hide()
	get_node("nickedit").set_text(nick2[1])

	#global.add_player("unknonw")
	#global.add_player_nick("unknonw", "unknonw")
	
func _process(dt):
	_process_data()
	
func _process_data():
	for data in global.nm.get_data():
		if global.nm.isServer:
			print ("server data:", global.nm.get_data())
		else:
			print ("client data:", global.nm.get_data())
