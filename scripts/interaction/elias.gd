extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("อย่ามายุ่งกับฉัน...")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("elias1")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ฉันไม่มีอะไรจะบอกแล้ว...")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c7_c12":
		EvidenceManager.unlock_evidence("C7")
		EvidenceManager.unlock_evidence("C12")
		QuestManager.complete_objective("meet_elias", "meet_elias1")
		QuestManager.start_quest("meet_ingrid")
