class_name KeyboardMinigame
extends Control


signal minigame_finished(result: String)


@export_category("Progress")
@export var start_progress: float = 50.0
@export var correct_amount: float = 10.0
@export var wrong_amount: float = 10.0
@export var decay_amount: float = 1.0


@export_category("Keyboard")
@export var available_keys: String = "QWERASDF"


@export_category("Key Timer")
@export var key_time_limit: float = 2.0


@onready var progress_bar: ProgressBar = $ProgressBar
@onready var time_progress_bar: ProgressBar = $TimeProgressBar
@onready var decay_timer: Timer = $DecayTimer
@onready var key_label: Label = $KeyLabel


var current_key: Key = KEY_NONE
var is_playing: bool = false
var key_time_left: float = 0.0


func _ready() -> void:
	decay_timer.timeout.connect(_on_decay_timer_timeout)


func start_minigame() -> void:
	is_playing = true

	progress_bar.value = start_progress

	decay_timer.start()

	_generate_new_key()


func _process(delta: float) -> void:
	if not is_playing:
		return

	key_time_left -= delta
	time_progress_bar.value = key_time_left

	if key_time_left <= 0.0:
		_time_out()


func _generate_new_key() -> void:
	var random_index: int = randi_range(
		0,
		available_keys.length() - 1
	)

	var key_string: String = available_keys[random_index]

	current_key = OS.find_keycode_from_string(key_string)

	key_label.text = key_string

	key_time_left = key_time_limit
	time_progress_bar.max_value = key_time_limit
	time_progress_bar.value = key_time_limit


func _unhandled_key_input(event: InputEvent) -> void:
	if not is_playing:
		return

	if not event is InputEventKey:
		return

	if not event.pressed:
		return

	if event.echo:
		return

	var key_event: InputEventKey = event

	if key_event.keycode == current_key:
		_correct_input()
	else:
		_wrong_input()


func _correct_input() -> void:
	progress_bar.value += correct_amount

	if progress_bar.value >= 100.0:
		_finish("success")
		return

	_generate_new_key()


func _wrong_input() -> void:
	progress_bar.value -= wrong_amount

	if progress_bar.value <= 0.0:
		_finish("fail")
		return

	_generate_new_key()


func _time_out() -> void:
	progress_bar.value -= wrong_amount

	if progress_bar.value <= 0.0:
		_finish("fail")
		return

	_generate_new_key()


func _on_decay_timer_timeout() -> void:
	if not is_playing:
		return

	progress_bar.value -= decay_amount

	if progress_bar.value <= 0.0:
		_finish("fail")


func _finish(result: String) -> void:
	if not is_playing:
		return

	is_playing = false

	decay_timer.stop()

	minigame_finished.emit(result)

	hide()
