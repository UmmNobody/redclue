extends Interactable

func start_not_started_interaction() -> void:
	pass

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("โซฟาตัวนี้นอนไม่สบายเอาซะเลย...")
	QuestManager.complete_objective("meet_enmund", "meet_enmund_1")

func start_completed_interaction() -> void:
	pass
