extends Control

func _ready() -> void:
	MusicManager.play_music("mainmenu")

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	GameManager.restart_game()
	get_tree().change_scene_to_file("res://scenes/cutscenes/start_cutscene.tscn")


func _on_option_button_pressed() -> void:
	var option_menu = $OptionsMenu
	option_menu.open()
