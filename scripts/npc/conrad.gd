extends Interactable


func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ว่าไงคุณ Reed มีอะไรให้ผมช่วยไหม")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("conrad3")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ว่าไงคุณ Reed มีอะไรให้ผมช่วยไหม")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "start_final":
		var minigame = get_tree().get_first_node_in_group("MinigameConrad")
		if minigame :
			minigame.open_game()
		
