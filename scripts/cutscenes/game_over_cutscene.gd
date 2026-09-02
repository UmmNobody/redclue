extends Control

func _ready() -> void:
	hide()

func start() -> void:
	show()
	Dialogic.signal_event.connect(_dialogic_signal)
	Dialogic.start("game_over_cutscene")

func _dialogic_signal(argument: String) -> void :
	if argument == "over_cutscene_end":
		hide()
		Dialogic.signal_event.disconnect(_dialogic_signal)
