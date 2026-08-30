class_name Interactable
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

@export_category("Quest Requirement")
@export var required_quest_id: String = ""
@export var short_message: String = ""

var is_highlighted: bool = false


func _ready() -> void:
	sprite.material = sprite.material.duplicate()


# =========================================================
# Interact
# =========================================================

func interact(player: CharacterBody2D) -> void:
	var quest_state := get_quest_state()

	match quest_state:
		QuestManager.QuestState.NOT_STARTED:
			start_not_started_interaction()

		QuestManager.QuestState.ACTIVE:
			start_active_interaction()

		QuestManager.QuestState.COMPLETED:
			start_completed_interaction()


func get_quest_state() -> QuestManager.QuestState:
	if required_quest_id.is_empty():
		return QuestManager.QuestState.ACTIVE

	return QuestManager.get_quest_state(required_quest_id)


func start_not_started_interaction() -> void:
	print("not started interaction : " + name)
	# Override me

func start_active_interaction() -> void:
	print("active interaction : " + name)
	# Override me

func start_completed_interaction() -> void:
	print("completed interaction : " + name)
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

# =========================================================
# Highlight
# =========================================================

func set_highlight(enabled: bool) -> void:
	var material := sprite.material as ShaderMaterial

	if material:
		material.set_shader_parameter("outline_enabled", enabled)
