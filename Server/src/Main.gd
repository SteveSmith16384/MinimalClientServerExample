extends Node2D

var client_class = preload("ClientConnection.tscn")

var server : TCP_Server

func _ready():
	server = TCP_Server.new()
	var _res = server.listen(5000)
	pass


func _process(_delta):
	if server.is_connection_available() == false:
		return
		
	var client = server.take_connection()
	print("Client connected")
	
	var client_connection = client_class.instance()
	client_connection.connect("disconnected", self, "_on_disconnected")
	client_connection._stream = client
	
	$Clients.add_child(client_connection)
	pass


func _on_PingTimer_timeout():
	for client in $Clients.get_children():
		client.send("Hello!".to_ascii())
	pass


func _on_disconnected(client):
	print("Client disconnected")
	$Clients.remove_child(client)
	print(str($Clients.get_child_count()) + " clients remaining")
	pass
