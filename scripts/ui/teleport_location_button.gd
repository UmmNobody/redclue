extends Button

@export var location_id: String = ""

func _ready() -> void:
	refresh()

func refresh() -> void:
	var unlocked := LocationManager.is_location_unlocked(location_id)

	disabled = not unlocked
