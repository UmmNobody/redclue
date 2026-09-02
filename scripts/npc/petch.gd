extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("Petch เจ้าของร้าน Halloway Apothecary")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("petch1")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("Petch เจ้าของร้าน Halloway Apothecary ได้ข้อมูลมากพอแล้วไม่มีอะไรต้องถามเขาอีก")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c12":
		EvidenceManager.unlock_evidence("C12")
		QuestManager.complete_objective("meet_petch", "meet_petch1")
		QuestManager.start_quest("find_criminal")
