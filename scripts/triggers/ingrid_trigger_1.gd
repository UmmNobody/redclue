extends EventTrigger

func trigger_event() -> void:
	set_start_dialogue()
	Dialogic.start("ingrid1")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c8" :
		EvidenceManager.unlock_evidence("C8")
		QuestManager.complete_objective("meet_ingrid", "meet_ingrid1")
