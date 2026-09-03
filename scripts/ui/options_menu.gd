extends Control

func _ready() -> void:
	hide()

func open() -> void: 
	show()
	
func close() -> void: 
	hide()

func _on_back_pressed() -> void:
	close()
