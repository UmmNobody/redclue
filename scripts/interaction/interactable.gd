class_name Interactable
extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

var is_highlighted: bool = false

func _ready() -> void:
	sprite.material = sprite.material.duplicate()

func interact(player: CharacterBody2D) -> void:
	print("Interacted with: ", name)

func set_highlight(enabled: bool) -> void:
	var material := sprite.material as ShaderMaterial

	if material:
		material.set_shader_parameter("outline_enabled", enabled)
