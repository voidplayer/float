extends Node

var isServer
var server = null

var peers = {}

#HELPER CLASS
class Peer:
	var id = "unknown"
	var stream
	func set_stream(connection):
		if !connection:
			print("No connection")
		stream = PacketPeerStream.new()
		stream.set_stream_peer(connection)

# protocol
const YOURID = 0

func _process(delta):
	if isServer:
		_process_server()
	else: #client
		_process_client()

#SERVER
func _process_server():
	#onServerUpdate()
	if server.is_connection_available():
		print("NEW peer connected")
		var peer = Peer.new()
		peer.set_stream(server.take_connection())
		peer.id = "n"+str(peers.size()+1)
		peer.stream.put_var([YOURID, peer.id])
		peers[peer.id] = peer

#this wont work until theo fix is pushed
func create_server():
	server = TCP_Server.new()
	if !server.listen(9955):
		isServer = true
		print("Server is up and running")
	else:
		print("unable to create server")
		return false
	set_process(true)
	return true

func onServerUpdate():

	for p in peers:
		print("peer: ", peers[p])

	for player in get_scene().get_nodes_in_group("players"):
		if !player.connection.is_connected():
			print("player disconected")
			

func get_data():
	var data = []
	for p in peers:
		if peers[p].stream.get_available_packet_count()>0:
			var d = peers[p].stream.get_var()
			if d != null and data.size() > 0:
				data.append(d)
	return data

func send_data(id, data):
	pass

func broadcast(data):
	for p in peers:
		peers[p].stream.put_var(data)

#CLIENT
func _process_client():
	pass
	#onClientUpdate()

func connect_to_server():
	var peer = Peer.new()
	var connection = StreamPeerTCP.new()
	connection.connect("127.0.0.1", 9955)
	peer.set_stream(connection)

	#we dont the id yet, the server will send it to us
	peers["unknown"] = peer
	set_process(true)
	if connection.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		isServer = false
		return true
	else:
		return false


func onClientUpdate():
	pass
	#var data = peerstream.get_var()
	#if data != null and data.size() > 0:

func _process_data(data):
	#if data[0] == YOURID:
	#	id = data[1]
	pass

