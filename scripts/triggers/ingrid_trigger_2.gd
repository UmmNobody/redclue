extends EventTrigger

func trigger_event() -> void:
	print("Dudududu... Dudududu")
	set_start_dialogue()
	await get_tree().create_timer(2.0).timeout
	Dialogic.start("holm3")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	QuestManager.start_quest("meet_conrad")
	LocationManager.unlock_location("weissindustrial")

func dialogic_signal(argument: String) :
	pass
	# Override me
