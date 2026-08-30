extends Interactable

func start_not_started_interaction() -> void:
	pass

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("โซฟาตัวนี้นอนไม่สบายเอาซะเลย...")

func start_completed_interaction() -> void:
	pass
