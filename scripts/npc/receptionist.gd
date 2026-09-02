extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("พนักงานต้อนรับของ Weiss Industrial")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("reception")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("พนักงานต้อนรับของ Weiss Industrial")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)

func dialogic_signal(argument: String) :
	if argument == "reception":
		QuestManager.complete_objective("meet_conrad1","meet_conrad1")
		QuestManager.start_quest("meet_conrad2")
