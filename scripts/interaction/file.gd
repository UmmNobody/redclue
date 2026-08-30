extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("แฟ้มเก่าๆ เล่มหนึ่ง")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("file")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ฉันน่าจะลองไปตามหาคนในรายชื่อแฟ้มนี้ดู")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c4":
		EvidenceManager.unlock_evidence("C4")
		QuestManager.complete_objective("explore_room1", "explore_room1_2")
		if QuestManager.is_objective_completed("explore_room1", "explore_room1_1") :
			QuestManager.start_quest("ask_garret")
