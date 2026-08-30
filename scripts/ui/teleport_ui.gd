extends Control

signal location_selected(location_id: String)

@onready var office_button: Button = $Map/OfficeButton
@onready var factory_button: Button = $Map/FactoryButton
@onready var filmstore_button: Button = $Map/FilmStoreButton


func _ready() -> void:
	visible = false

	office_button.pressed.connect(_on_location_pressed.bind("office"))
	factory_button.pressed.connect(_on_location_pressed.bind("factory"))
	filmstore_button.pressed.connect(_on_location_pressed.bind("filmstore"))

	refresh_locations()


func open() -> void:
	refresh_locations()
	visible = true


func close() -> void:
	visible = false


func refresh_locations() -> void:
	office_button.disabled = not LocationManager.is_location_unlocked("office")
	factory_button.disabled = not LocationManager.is_location_unlocked("factory")
	filmstore_button.disabled = not LocationManager.is_location_unlocked("filmstore")

func _on_location_pressed(location_id: String) -> void:
	close()
	GameManager.change_location(location_id)


func _on_close_button_pressed() -> void:
	close()
