class_name EventTrigger
extends Area2D

@export_category("Quest Requirement")
@export var required_quest_id: String = ""

var has_triggered: bool = false

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	if has_triggered:
		return
	if not can_trigger():
		return

	has_triggered = true
	trigger_event()


func can_trigger() -> bool:
	if required_quest_id.is_empty():
		return true

	return QuestManager.current_quest != null \
		and QuestManager.current_quest.quest_id == required_quest_id


func trigger_event() -> void:
	print("Event Triggered: ", name)
