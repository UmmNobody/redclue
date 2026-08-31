extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("กระดานบอร์ดเก่าๆ ที่ไม่ค่อยได้ใช้แล้ว...")

func start_active_interaction() -> void:
	var evidence_board = get_tree().get_first_node_in_group("EvidenceBoard")

	if evidence_board:
		evidence_board.open()
		QuestManager.complete_objective("back_to_office", "back_to_office1")
	else:
		print("EvidenceBoard not found")

func start_completed_interaction() -> void:
	var evidence_board = get_tree().get_first_node_in_group("EvidenceBoard")

	if evidence_board:
		evidence_board.open()
	else:
		print("EvidenceBoard not found")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)

func dialogic_signal(argument: String) -> void:
	pass
