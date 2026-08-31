extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$MinigameKeyboard.minigame_finished.connect(_on_minigame_finished)
	#$MinigameKeyboard.start_minigame()
	pass

func _on_minigame_finished(result: String) -> void:
	if result == "success":
		print("MINIGAME SUCCESS")

	elif result == "fail":
		print("MINIGAME FAIL")
