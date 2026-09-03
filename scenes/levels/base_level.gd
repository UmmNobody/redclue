extends Node

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	_set_player_spawn()

func _set_player_spawn() -> void:
	if GameManager.pending_teleport:
		var spawn_point: Marker2D = get_parent().get_node("TeleportSpawn")

		player.global_position = spawn_point.global_position
		GameManager.pending_teleport = false

	elif get_parent().has_node("InitialPlayerSpawn"):
		var spawn_point: Marker2D = get_parent().get_node("InitialPlayerSpawn")

		player.global_position = spawn_point.global_position


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")


func _on_setting_button_pressed() -> void:
	var option_menu = get_tree().get_first_node_in_group("OptionsMenu")
	
	if option_menu:
		option_menu.open()


func _on_notebook_button_pressed() -> void:
	var notebook = get_tree().get_first_node_in_group("Notebook")
	
	if notebook:
		notebook.open_notebook()
	else:
		print("not f")
