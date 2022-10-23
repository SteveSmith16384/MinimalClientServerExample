extends Node2D

var client

func _ready():
	client = $Client# Client.new()

	client.connect_to_host("127.0.0.1", 5000)
	
	
	pass
	
	
func _process(delta):
	pass


func _on_Client_data(pba: PoolByteArray):
	var s = pba.get_string_from_ascii()
	print("Received: " + s)
	pass
