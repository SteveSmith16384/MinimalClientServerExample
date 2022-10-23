#class_name Client
extends Node

#signal connected      # Connected to server
signal data(client, data)           # Received data from server
signal disconnected(client)   # Disconnected from server
signal error(client, msg)          # Error with connection to server

var _status: int = 0
var _stream: StreamPeerTCP


func _ready() -> void:
	_status = _stream.get_status()
	pass
	
	
func send(data: PoolByteArray) -> bool:
	if _status != _stream.STATUS_CONNECTED:
		print("Error: Stream is not currently connected.")
		return false
	var error: int = _stream.put_data(data)
	if error != OK:
		print("Error writing to stream: ", error)
		return false
	return true
	
	
func _process(delta: float) -> void:
	var new_status: int = _stream.get_status()
	if new_status != _status:
		_status = new_status
		match _status:
			_stream.STATUS_NONE:
				print("Disconnected from host.")
				emit_signal("disconnected", self)
#			_stream.STATUS_CONNECTING:
#				print("Connecting to host.")
#			_stream.STATUS_CONNECTED:
#				print("Connected to host.")
#				emit_signal("connected")
			_stream.STATUS_ERROR:
				print("Error with socket stream.")
				emit_signal("error", self, "Error with socket stream.")

	if _status == _stream.STATUS_CONNECTED:
		var available_bytes: int = _stream.get_available_bytes()
		if available_bytes > 0:
			print("available bytes: ", available_bytes)
			var data: Array = _stream.get_partial_data(available_bytes)
			# Check for read error.
			if data[0] != OK:
				print("Error getting data from stream: ", data[0])
				emit_signal("error", self, "Error getting data from stream: " + data[0])
			else:
				emit_signal("data", self, data[1])
	pass
	
	
