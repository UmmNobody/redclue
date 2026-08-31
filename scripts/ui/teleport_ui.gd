extends Control

signal location_selected(location_id: String)

@onready var office_button: Button = $Map/OfficeButton
@onready var factory_button: Button = $Map/FactoryButton
@onready var filmstore_button: Button = $Map/FilmStoreButton
@onready var bar_button: Button = $Map/BarButton
@onready var ingrid_button: Button = $Map/IngridButton
@onready var weiss_button: Button = $Map/WeissButton

func _ready() -> void:
	visible = false

	office_button.pressed.connect(_on_location_pressed.bind("office"))
	factory_button.pressed.connect(_on_location_pressed.bind("factory"))
	filmstore_button.pressed.connect(_on_location_pressed.bind("filmstore"))
	bar_button.pressed.connect(_on_location_pressed.bind("bar"))
	ingrid_button.pressed.connect(_on_location_pressed.bind("ingridhouse"))
	weiss_button.pressed.connect(_on_location_pressed.bind("weissindustrial"))

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
	bar_button.disabled = not LocationManager.is_location_unlocked("bar")
	ingrid_button.disabled = not LocationManager.is_location_unlocked("ingridhouse")
	weiss_button.disabled = not LocationManager.is_location_unlocked("weissindustrial")

func _on_location_pressed(location_id: String) -> void:
	close()
	GameManager.change_location(location_id)


func _on_close_button_pressed() -> void:
	close()
