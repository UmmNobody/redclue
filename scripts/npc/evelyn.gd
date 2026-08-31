extends Interactable


func start_not_started_interaction() -> void:
	pass

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("อุปกรณ์อยู่ห้องด้านในสุด นายเข้าไปได้เลย")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("เรียบร้อยแล้วหลอ งั้นไว้เจอกันโอกาสหน้านะ Devid")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)

func dialogic_signal(argument: String) :
	pass
	# Override me
