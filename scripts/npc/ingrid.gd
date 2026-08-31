extends Interactable


func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ขอฉันอยู่คนเดียวซักพักหน่อย...")

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ขอฉันอยู่คนเดียวซักพักหน่อย...")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ขอฉันอยู่คนเดียวซักพักหน่อย...")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	pass
