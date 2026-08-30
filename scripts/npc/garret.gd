extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("Garret นั่งนิ่งตัวสั่นอยู่เขาคงตกใจมาก")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("garret")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("Garret นั่งนิ่งตัวสั่นอยู่เขาคงตกใจมาก")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c5":
		EvidenceManager.unlock_evidence("C5")
		QuestManager.complete_objective("ask_garret", "ask_garret1")
		QuestManager.start_quest("check_side_factory")
