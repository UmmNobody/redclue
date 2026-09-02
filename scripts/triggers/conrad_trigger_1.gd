extends EventTrigger

func trigger_event() -> void:
	set_start_dialogue()
	Dialogic.start("conrad1")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c9":
		EvidenceManager.unlock_evidence("C9")
		QuestManager.complete_objective("meet_conrad2", "meet_conrad2")
