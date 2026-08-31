extends EventTrigger

func trigger_event() -> void:
	set_start_dialogue()
	Dialogic.start("meet_enmund")
	
func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	QuestManager.complete_objective("meet_enmund", "meet_enmund_1")
	QuestManager.start_quest("check_body")
