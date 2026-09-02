extends Interactable

@onready var teleport_marker: Marker2D = $TeleportMarker

func start_not_started_interaction() -> void:
	if short_message:
		set_start_dialogue()
		DialogueManager.show_short_message(short_message)

func start_active_interaction() -> void:
	if teleport_marker:
		SfxManager.play_sfx("door")
		player.global_position = teleport_marker.global_position
		GameManager.room_changed.emit()
	else:
		print("Not found teleport_marker")

func start_completed_interaction() -> void:
	if teleport_marker:
		SfxManager.play_sfx("door")
		player.global_position = teleport_marker.global_position
		GameManager.room_changed.emit()
	else:
		print("Not found teleport_marker")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	# Override me
