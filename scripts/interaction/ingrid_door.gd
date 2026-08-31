extends Interactable

@onready var teleport_marker: Marker2D = $TeleportMarker


func start_not_started_interaction() -> void:
	if short_message:
		set_start_dialogue()
		DialogueManager.show_short_message(short_message)

func start_active_interaction() -> void:
	knockdoor()

func start_completed_interaction() -> void:
	knockdoor()

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	
	if teleport_marker:
		player.global_position = teleport_marker.global_position
		GameManager.room_changed.emit()
	else:
		print("Not found teleport_marker")

func knockdoor() -> void:
	set_start_dialogue()
	Dialogic.start("knockdoor")
