extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("กาน้ำและแก้วเก่าใบหนึ่ง...")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("cup_pot")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("นี้อาจจะเป็นเบาะแสอะไรซักอย่างก็ได้...")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c3":
		EvidenceManager.unlock_evidence("C3")
		QuestManager.complete_objective("explore_room1", "explore_room1_1")
		if QuestManager.is_objective_completed("explore_room1", "explore_room1_2") :
			QuestManager.start_quest("ask_garret")
