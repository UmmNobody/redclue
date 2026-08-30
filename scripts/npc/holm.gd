extends Interactable

func start_not_started_interaction() -> void:
	print("not started interaction : " + name)
	# Override me

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("เดี๋ยวฉันช่วยจัดการเรื่องเอาหลักฐานไปให้หมอวิเคราห์เอง นายลงไปสอบถาม Garret เลย")

func start_completed_interaction() -> void:
	print("completed interaction : " + name)
	# Override me

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	# Override me
