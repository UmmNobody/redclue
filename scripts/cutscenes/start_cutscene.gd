extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	start()

func start() -> void:
	show()
	Dialogic.signal_event.connect(_dialogic_signal)
	Dialogic.start("start_cutscene")
	
func _dialogic_signal(argument: String) -> void :
	if argument == "start_cutscene_end":
		hide()
		Dialogic.signal_event.disconnect(_dialogic_signal)
		get_tree().change_scene_to_file("res://scenes/levels/office.tscn")
