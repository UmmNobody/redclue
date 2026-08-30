extends Node

signal location_unlocked(location_id: String)

var locations: Dictionary = {
	"office": {
		"scene_path": "res://scenes/levels/office.tscn"
	},
	"factory": {
		"scene_path": "res://scenes/levels/factory.tscn"
	},
	"filmstore": {
		"scene_path": "res://scenes/levels/filmstore.tscn"
	}
}

var unlocked_locations: Dictionary = {}

func _ready() -> void:
	unlock_location("office")

func unlock_location(location_id: String) -> void:
	if not locations.has(location_id):
		return

	if unlocked_locations.has(location_id):
		return

	unlocked_locations[location_id] = true

	print("Location Unlocked: ", location_id)

	location_unlocked.emit(location_id)


func is_location_unlocked(location_id: String) -> bool:
	return unlocked_locations.has(location_id)


func get_location_scene(location_id: String) -> String:
	if not locations.has(location_id):
		return ""

	return locations[location_id]["scene_path"]
