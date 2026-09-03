extends Control

func _ready() -> void:
	hide()

func start() -> void:
	show()
	SfxManager.play_sfx("police")
	Dialogic.signal_event.connect(_dialogic_signal)
	Dialogic.start("game_win_cutscene")

func _dialogic_signal(argument: String) -> void :
	if argument == "win_cutscene_end":
		hide()
		Dialogic.signal_event.disconnect(_dialogic_signal)
		get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
