class_name EvidenceCard
extends Panel


@onready var evidence_image: TextureRect = $EvidenceImage
@onready var evidence_name: Label = $EvidenceName

var evidence_id: String = ""
var board: Control

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var is_connecting: bool = false


func _ready() -> void:
	evidence_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	evidence_name.mouse_filter = Control.MOUSE_FILTER_IGNORE


func setup(evidence: Evidence) -> void:
	evidence_id = evidence.evidence_id
	evidence_name.text = evidence.evidence_name

	if evidence.image:
		evidence_image.texture = evidence.image
	elif evidence.icon:
		evidence_image.texture = evidence.icon


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# ถ้ากด Shift + คลิกซ้าย จะเป็นการลากเส้นเชื่อม
			if Input.is_key_pressed(KEY_SHIFT):
				is_connecting = true
				var board_owner = _get_board_owner()
				if board_owner:
					board_owner.start_connecting(self)
			else:
				_start_drag()


func _input(event: InputEvent) -> void:
	# การลากการ์ดปกติ
	if is_dragging:
		if event is InputEventMouseMotion:
			global_position = get_global_mouse_position() + drag_offset
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_stop_drag()

	# การลากเส้นเชื่อม
	elif is_connecting:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_connecting = false
			var board_owner = _get_board_owner()
			if board_owner:
				# หาการ์ดที่เมาส์ปล่อยลงไปทับ
				var target_card = _get_card_under_mouse()
				board_owner.finish_connecting(target_card)


func _start_drag() -> void:
	if board == null:
		return
	is_dragging = true
	drag_offset = global_position - get_global_mouse_position()

	if get_parent() != board:
		var old_global_position: Vector2 = global_position
		get_parent().remove_child(self)
		board.add_child(self)
		global_position = old_global_position


func _stop_drag() -> void:
	is_dragging = false
	var board_owner = _get_board_owner()
	if board_owner and board_owner.has_method("save_card_position"):
		board_owner.save_card_position(evidence_id, position)


func _get_board_owner() -> EvidenceBoard:
	return find_parent("EvidenceBoard") as EvidenceBoard


func _get_card_under_mouse() -> EvidenceCard:
	var mouse_pos = get_global_mouse_position()
	for child in board.get_children():
		if child is EvidenceCard and child.get_global_rect().has_point(mouse_pos):
			return child
	return null
