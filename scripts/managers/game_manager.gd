extends Node

var phone_ring_played: bool = false

# Teleport
var pending_teleport: bool = false
var current_location_id: String = ""


func change_location(location_id: String) -> void:
	var scene_path := LocationManager.get_location_scene(location_id)

	if scene_path.is_empty():
		print("Invalid Location: ", location_id)
		return

	if not LocationManager.is_location_unlocked(location_id):
		print("Location Locked: ", location_id)
		return

	current_location_id = location_id
	pending_teleport = true

	get_tree().change_scene_to_file(scene_path)
