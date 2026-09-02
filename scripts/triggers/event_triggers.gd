class_name EventTrigger
extends Area2D


@export_category("Event")
@export var event_id: String = ""

@export_category("Quest Requirement")
@export var required_quest_id: String = ""
@export var required_completed_quest_id: String = ""

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var has_triggered: bool = false


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	if has_triggered:
		return

	if not can_trigger():
		return

	if not GameManager.check_and_register_event(event_id):
		return

	has_triggered = true
	trigger_event()


func can_trigger() -> bool:
	# ต้องเป็น Quest ปัจจุบัน
	if not required_quest_id.is_empty():
		if QuestManager.current_quest == null:
			return false

		if QuestManager.current_quest.quest_id != required_quest_id:
			return false

	# ต้องเคย Complete Quest ที่กำหนด
	if not required_completed_quest_id.is_empty():
		if not QuestManager.completed_quests.has(required_completed_quest_id):
			return false

	return true


func trigger_event() -> void:
	print("Event Triggered: ", name)
	# Override me


func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	pass
	# Override me

func set_start_dialogue() -> void:
	player.set_movement_enabled(false)
	Dialogic.timeline_ended.connect(ended)
	Dialogic.signal_event.connect(dialogic_signal)
