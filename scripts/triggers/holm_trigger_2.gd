extends EventTrigger

func trigger_event() -> void:
	SfxManager.play_sfx("phone1")
	set_start_dialogue()
	await get_tree().create_timer(2.0).timeout
	Dialogic.start("holm4")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "meet_harder":
		QuestManager.start_quest("meet_harder")
