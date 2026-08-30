extends Interactable

func start_not_started_interaction() -> void:
	print("not started interaction : " + name)
	# Override me

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ยุ่งจริงๆ เลยวันนี้ นายคิดเหมือนกันไหม Devid")

func start_completed_interaction() -> void:
	print("completed interaction : " + name)
	# Override me

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	# Override me
