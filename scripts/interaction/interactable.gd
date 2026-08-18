class_name Interactable
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

@export_category("Quest Requirement")
@export var required_quest_id: String = ""

var is_highlighted: bool = false

func _ready() -> void:
	sprite.material = sprite.material.duplicate()

# interact function
func interact(player: CharacterBody2D) -> void:
	if can_interact():
		start_valid_interaction()
	else:
		start_invalid_interaction()

func start_valid_interaction():
	print("valid interactrion : " + name)
	
func start_invalid_interaction():
	print("invalid interactrion : " + name)

func can_interact() -> bool:
	if required_quest_id.is_empty():
		return true

	return QuestManager.current_quest != null \
		and QuestManager.current_quest.quest_id == required_quest_id

func ended():
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)

# highlight function

func set_highlight(enabled: bool) -> void:
	var material := sprite.material as ShaderMaterial

	if material:
		material.set_shader_parameter("outline_enabled", enabled)
