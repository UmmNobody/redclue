extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_master_slider_value_changed(value: float) -> void:
	var bus_index := AudioServer.get_bus_index("Master")

	if bus_index == -1:
		return

	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)


func _on_music_slider_value_changed(value: float) -> void:
	MusicManager.set_volume(value)


func _on_sfx_h_slider_value_changed(value: float) -> void:
	SfxManager.set_volume(value)
