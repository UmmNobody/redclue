extends Interactable

func start_not_started_interaction() -> void:
	DialogueManager.show_short_message("เสียงโทรศัพท์ยังดังไม่หยุด ... ไปรับโทรศัพท์ก่อนดีกว่า")

func start_active_interaction() -> void:
	var teleport_ui = get_tree().get_first_node_in_group("TeleportUI")

	if teleport_ui:
		teleport_ui.open()
	else:
		print("TeleportUI not found")

func start_completed_interaction() -> void:
	var teleport_ui = get_tree().get_first_node_in_group("TeleportUI")

	if teleport_ui:
		teleport_ui.open()
	else:
		print("TeleportUI not found")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	# Override me
