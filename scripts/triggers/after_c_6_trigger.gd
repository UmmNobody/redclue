extends EventTrigger

func trigger_event() -> void:
	set_start_dialogue()
	Dialogic.start("after_c6")


func ended() -> void:
	if Dialogic.timeline_ended.is_connected(ended):
		Dialogic.timeline_ended.disconnect(ended)

	player.set_movement_enabled(true)
	QuestManager.start_quest("meet_evelyn")
	LocationManager.unlock_location("filmstore")
