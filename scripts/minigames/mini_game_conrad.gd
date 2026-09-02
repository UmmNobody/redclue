extends Control

@export var max_time: float = 120.0

var current_time: float = 120.0
var is_active: bool = false

@onready var time_bar: ProgressBar = $TimeBar


func _ready() -> void:
	hide()

	time_bar.max_value = max_time
	time_bar.value = max_time

func open_game() -> void:
	MusicManager.play_music("final")
	show()
	reset_game()
	Dialogic.start("conrad_countdown")

func close_game() -> void:
	is_active = false
	hide()


func reset_game() -> void:
	is_active = false
	current_time = max_time
	time_bar.value = max_time
	if not Dialogic.signal_event.is_connected(_on_dialogic_signal):
		Dialogic.signal_event.connect(_on_dialogic_signal)


func start_countdown() -> void:
	is_active = true


func _process(delta: float) -> void:
	if not is_active:
		return

	current_time -= delta
	time_bar.value = current_time

	if current_time <= 0.0:
		_trigger_game_over()


func _on_dialogic_signal(argument: String) -> void:
	if argument == "start_conrad_countdown":
		start_countdown()
		return

	if argument == "wrong":
		_deduct_time(15.0)

	elif argument == "win":
		_trigger_win()

	elif argument == "win_cutscene":
		_game_win_cutscene()


func _deduct_time(amount: float) -> void:
	current_time = max(0.0, current_time - amount)
	time_bar.value = current_time

	if current_time <= 0.0:
		_trigger_game_over()


func _trigger_game_over() -> void:
	close_game()
	Dialogic.end_timeline()
	await Dialogic.timeline_ended
	var gameover_cutscene = get_tree().get_first_node_in_group("GameOverCutscene")
	if gameover_cutscene:
		gameover_cutscene.start()

func _trigger_win() -> void:
	close_game()
	QuestManager.complete_objective("final_quest", "final_quest1")
	Dialogic.start("game_win")


func _game_win_cutscene() -> void:
	var gamewin_cutscene = get_tree().get_first_node_in_group("GameWinCutscene")

	if gamewin_cutscene:
		gamewin_cutscene.start()
