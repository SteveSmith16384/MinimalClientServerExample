extends Node2D

var server : TCP_Server

var clients = []

func _ready():
	server = TCP_Server.new()
	var _res = server.listen(5000)
	pass


func _process(_delta):
	if server.is_connection_available() == false:
		return
		
	var client = server.take_connection()
	print("Client connected")
	clients.push_back(client)
	pass


func _on_PingTimer_timeout():
	for client in clients:
		client.put_data("Hello!".to_ascii())
	pass
