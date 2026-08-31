extends Interactable

@onready var minigame_keyboard = get_tree().get_first_node_in_group("MinigameKeyboard")

var is_playing_minigame: bool = false

func _ready() -> void:
	if minigame_keyboard:
		minigame_keyboard.minigame_finished.connect(_on_minigame_finished)

func start_not_started_interaction() -> void:
	pass

func start_active_interaction() -> void:
	if is_playing_minigame:
		return
		
	set_start_dialogue()
	Dialogic.start("start_minigame")

func start_completed_interaction() -> void:
	pass

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)

func dialogic_signal(argument: String) :
	if argument == "start_minigame":
		is_playing_minigame = true

		if minigame_keyboard:
			minigame_keyboard.start_minigame()
	if argument == "sucess_minigame" || argument == "fail_minigame":
		player.set_movement_enabled(true)


func _on_minigame_finished(success: bool) -> void:
	is_playing_minigame = false

	if success:
		_on_minigame_success()
	else:
		_on_minigame_fail()
		
		
func _on_minigame_success() -> void:
	set_start_dialogue()
	Dialogic.start("sucess_minigame")
	QuestManager.complete_objective("develop_film", "develop_film1")
	QuestManager.start_quest("back_to_office")

func _on_minigame_fail() -> void:
	set_start_dialogue()
	Dialogic.start("fail_minigame")
