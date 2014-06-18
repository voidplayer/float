extends Node

const MENU = 0
const PLAYING = 1
const GAMEOVER = 2
const SELECT1P = 3
const SELECT2P = 4
const SERVER = 5
const CLIENT = 6

var status = SELECT2P
var current_scene = null
var current_map = "res://map3.xml"

var nm = null

var id = "p1"

var players = [ "p1","p2" ]
var colors = { "p1":"green", "p2":"red" }
var nicks = {}

func add_player(pid):
	players.push_back(pid)

func set_player_color(pid, color):
	colors[pid] = color

func set_player_nick(pid, nick):
	nicks[pid] = nick

func reset():
	players = []
	colors = {}
	status = MENU


func _ready():
	var root = get_scene().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )

func goto_scene(scene):
	var s = ResourceLoader.load(scene)
	current_scene.queue_free()
	current_scene = s.instance()
	get_scene().get_root().add_child(current_scene)

func create_server():
	var nm_class = preload("res://network_manager.gd")
	nm = nm_class.new()
	add_child(nm)
	return nm.create_server()

func connect_to_server():
	var nm_class = preload("res://network_manager.gd")
	nm = nm_class.new()
	add_child(nm)
	return nm.connect_to_server()
