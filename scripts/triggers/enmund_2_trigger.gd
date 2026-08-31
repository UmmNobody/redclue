extends EventTrigger

func trigger_event() -> void:
	set_start_dialogue()
	Dialogic.start("enmund2")
	
func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me
