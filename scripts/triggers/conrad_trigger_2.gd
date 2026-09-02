extends EventTrigger

func trigger_event() -> void:
	set_start_dialogue()
	Dialogic.start("conrad2")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c10":
		EvidenceManager.unlock_evidence("C10")
