extends Node

const MENU = 0
const PLAYING = 1
const GAMEOVER = 2
const SELECT1P = 3
const SELECT2P = 4

var status = MENU
var current_scene = null

var server = null

func _process(delta):
	if server:
		onServerUpdate()
	if server.is_connection_available():
		

func _ready():
        var root = get_scene().get_root()
        current_scene = root.get_child( root.get_child_count() -1 )

func goto_scene(scene):
        var s = ResourceLoader.load(scene)
        current_scene.queue_free()
        current_scene = s.instance()
        get_scene().get_root().add_child(current_scene)

func onServer():
	server = TCP_Server.new()
	if !server.listen(9955):
		print("Server is up and running")
	set_process(true)

func onServerUpdate():
	for player in get_scene().get_nodes_in_group("players"):
		if !player.connection.is_connected()
			print("player disconected")