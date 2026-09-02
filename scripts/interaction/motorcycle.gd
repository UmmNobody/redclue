extends Interactable


func start_not_started_interaction() -> void:
	DialogueManager.show_short_message("จัดการธุระที่นี้ให้เสร็จก่อนดีกว่าค่อยไป ...")

func start_active_interaction() -> void:
	var teleport_ui = get_tree().get_first_node_in_group("TeleportUI")

	if teleport_ui:
		SfxManager.play_sfx("motor")
		teleport_ui.open()
	else:
		print("TeleportUI not found")

func start_completed_interaction() -> void:
	var teleport_ui = get_tree().get_first_node_in_group("TeleportUI")

	if teleport_ui:
		SfxManager.play_sfx("motor")
		teleport_ui.open()
	else:
		print("TeleportUI not found")
