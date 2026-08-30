extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("เศษก้นบุหรี่ที่ถูกทิ้งมาจากหน้าต่างห้องควบคุม")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("cigarette_stub")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("เศษก้นบุหรี่ที่ถูกทิ้งมาจากหน้าต่างห้องควบคุม")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c6":
		EvidenceManager.unlock_evidence("C6")
		QuestManager.complete_objective("check_side_factory", "check_side_factory")
