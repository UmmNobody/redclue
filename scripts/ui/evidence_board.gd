class_name EvidenceBoard
extends Control

signal correct_pair_found(card_a: String, card_b: String)
signal board_completed

const EVIDENCE_CARD = preload("res://scenes/ui/evidence_card.tscn")

@onready var evidence_hand: HBoxContainer = $Hand/EvidenceHand
@onready var placed_cards: Control = $Board/PlacedCards
@onready var board: Control = $Board
@onready var culprit_sprite: Sprite2D = $Board/CulpritSprite
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

# รายชื่อคู่หลักฐานที่ถูกต้อง (จับคู่สลับสลับซ้าย-ขวาได้)
var valid_pairs: Array = [
	["C1", "C8"],
	["C1", "C9"],
	["C3", "C11"],
	["C4", "C10"],
	["C5", "C6"],
	["C6", "C12"],
	["C11", "C12"],
]

# บันทึกเส้นที่เชื่อมสำเร็จแล้ว [{ "card_a": card1, "card_b": card2, "line": line_node }]
var active_connections: Array = []

var connecting_start_card: EvidenceCard = null
var preview_line: Line2D = null

# ตัวแปรสำหรับระบบลากบอร์ด (Panning)
var is_panning: bool = false
var pan_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	#LocationManager.unlock_location("weissindustrial")
	#QuestManager.start_quest("back_to_office")
	#EvidenceManager.unlock_evidence("C1")
	#EvidenceManager.unlock_evidence("C2")
	#EvidenceManager.unlock_evidence("C3")
	#EvidenceManager.unlock_evidence("C4")
	#EvidenceManager.unlock_evidence("C5")
	#EvidenceManager.unlock_evidence("C6")
	#EvidenceManager.unlock_evidence("C7")
	#videnceManager.unlock_evidence("C8")
	#EvidenceManager.unlock_evidence("C9")
	#videnceManager.unlock_evidence("C10")
	#videnceManager.unlock_evidence("C11")
	#EvidenceManager.unlock_evidence("C12")
	
	_load_evidence_cards()
	update_culprit_reveal()

func _process(_delta: float) -> void:
	# อัปเดตตำแหน่งเส้นพรีวิวระหว่างลากเมาส์
	if preview_line and connecting_start_card:
		var start_pos = _get_card_center(connecting_start_card)
		var mouse_pos = placed_cards.get_local_mouse_position()
		preview_line.set_point_position(0, start_pos)
		preview_line.set_point_position(1, mouse_pos)

	# อัปเดตตำแหน่งเส้นทั้งหมดที่เชื่อมสำเร็จแล้ว (เวลาลากขยับการ์ด)
	for conn in active_connections:
		var line: Line2D = conn["line"]
		line.set_point_position(0, _get_card_center(conn["card_a"]))
		line.set_point_position(1, _get_card_center(conn["card_b"]))

func open() -> void:
	player.set_movement_enabled(false)
	show()
	
func close() -> void:
	player.set_movement_enabled(true)
	hide()

# --- ระบบเริ่ม/จบ การลากเส้นเชื่อม ---

func start_connecting(from_card: EvidenceCard) -> void:
	connecting_start_card = from_card

	# สร้าง Line2D ชั่วคราวสำหรับพรีวิว
	preview_line = Line2D.new()
	preview_line.width = 3.0
	preview_line.default_color = Color(1, 0.2, 0.2, 0.6) # สีแดงโปร่งแสง
	preview_line.add_point(_get_card_center(from_card))
	preview_line.add_point(placed_cards.get_local_mouse_position())
	
	placed_cards.add_child(preview_line)
	# ดันเส้นไปไว้ด้านหลังการ์ด
	placed_cards.move_child(preview_line, 0)


func finish_connecting(target_card: EvidenceCard) -> void:
	if preview_line:
		preview_line.queue_free()
		preview_line = null

	if connecting_start_card == null or target_card == null or connecting_start_card == target_card:
		connecting_start_card = null
		return

	var id_a = connecting_start_card.evidence_id
	var id_b = target_card.evidence_id

	# ตรวจสอบว่าคู่ถูกต้องหรือไม่
	if _is_valid_pair(id_a, id_b):
		_create_permanent_line(connecting_start_card, target_card)

	connecting_start_card = null


func cancel_connecting() -> void:
	if preview_line:
		preview_line.queue_free()
		preview_line = null
	connecting_start_card = null


func _is_valid_pair(id_a: String, id_b: String) -> bool:
	for pair in valid_pairs:
		if (pair[0] == id_a and pair[1] == id_b) or (pair[0] == id_b and pair[1] == id_a):
			return true
	return false


func _create_permanent_line(card_a: EvidenceCard, card_b: EvidenceCard) -> void:
	# ตรวจสอบว่าเคยเชื่อมคู่นี้ไปแล้วหรือยัง
	for conn in active_connections:
		if (conn["card_a"] == card_a and conn["card_b"] == card_b) or (conn["card_a"] == card_b and conn["card_b"] == card_a):
			return

	var line = Line2D.new()
	line.width = 4.0
	line.default_color = Color.RED # สีแดงหลักฐาน
	line.add_point(_get_card_center(card_a))
	line.add_point(_get_card_center(card_b))

	placed_cards.add_child(line)
	placed_cards.move_child(line, 0)

	active_connections.append({
		"card_a": card_a,
		"card_b": card_b,
		"line": line
	})
	
	update_culprit_reveal()

	if active_connections.size() >= valid_pairs.size():
		board_completed.emit()
	else:
		correct_pair_found.emit(card_a.evidence_id, card_b.evidence_id)


func _get_card_center(card: EvidenceCard) -> Vector2:
	return card.position + (card.size / 2)

# Board function

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_MIDDLE):
		if event.pressed:
			is_panning = true
			pan_offset = board.position - get_global_mouse_position()
		else:
			is_panning = false

	elif event is InputEventMouseMotion and is_panning:
		var target_position: Vector2 = get_global_mouse_position() + pan_offset
		# จำกัดตำแหน่งก่อนนำไปใช้งานจริง
		board.position = _clamp_board_position(target_position)


func _clamp_board_position(target_pos: Vector2) -> Vector2:
	var viewport_size: Vector2 = get_viewport_rect().size
	# ดึงขนาดจริงของ Board (หากยังไม่ได้อัปเดต ให้ใช้ Custom Minimum Size)
	var board_size: Vector2 = board.size if board.size.x > 0 else board.custom_minimum_size

	# ขอบเขตต่ำสุด (ขอบขวาและขอบล่างของบอร์ดจะไม่เลื่อนจนเห็นช่องว่าง)
	var min_pos: Vector2 = Vector2(
		minf(0.0, viewport_size.x - board_size.x),
		minf(0.0, viewport_size.y - board_size.y)
	)
	
	# ขอบเขตสูงสุด (ขอบซ้ายและขอบบนของบอร์ดจะไม่หลุดเข้ามาข้างในจอ)
	var max_pos: Vector2 = Vector2.ZERO

	# ล็อคพิกัด target_pos ให้อยู่ระหว่าง min_pos กับ max_pos
	return target_pos.clamp(min_pos, max_pos)


func _load_evidence_cards() -> void:
	var evidences = EvidenceManager.get_unlocked_evidences()

	for evidence in evidences:
		var card: EvidenceCard = EVIDENCE_CARD.instantiate()

		# เช็กตำแหน่งจาก EvidenceManager แทน
		if EvidenceManager.placed_positions.has(evidence.evidence_id):
			placed_cards.add_child(card)
			card.board = placed_cards
			card.position = EvidenceManager.placed_positions[evidence.evidence_id]
		else:
			evidence_hand.add_child(card)
			card.board = placed_cards
			
		print(
			"Evidence: ", evidence.evidence_id,
			" | size = ", card.size,
			" | scale = ", card.scale,
			" | min_size = ", card.custom_minimum_size
		)

		card.setup(evidence)


func save_card_position(evidence_id: String, card_position: Vector2) -> void:
	# บันทึกลง EvidenceManager
	EvidenceManager.save_card_position(evidence_id, card_position)

func update_culprit_reveal() -> void:
	if not culprit_sprite or valid_pairs.is_empty():
		return

	var correct_count: int = 0

	for conn in active_connections:
		var id_a: String = conn["card_a"].evidence_id
		var id_b: String = conn["card_b"].evidence_id

		if _is_valid_pair(id_a, id_b):
			correct_count += 1

	# คำนวณค่า Alpha (0.0 ถึง 1.0)
	# - ไม่ถูกเลย (0) = 0.0 (ซ่อนตัว)
	# - ถูกบางคู่  = 0.x (จางๆ ตามสัดส่วน)
	# - ถูกครบ    = 1.0 (ชัดเจน 100%)
	var target_alpha: float = float(correct_count) / float(valid_pairs.size())

	# ใช้ Tween เล่น transition ค่อยๆ จางหรือชัดขึ้น 0.5 วินาที
	var tween = create_tween()
	print(target_alpha)
	tween.tween_property(culprit_sprite, "modulate:a", target_alpha, 0.5)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_close_button_pressed() -> void:
	close()
