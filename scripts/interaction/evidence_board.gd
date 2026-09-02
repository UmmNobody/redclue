extends Interactable

func _ready() -> void:
	var evidence_board = get_tree().get_first_node_in_group("EvidenceBoard")
	evidence_board.correct_pair_found.connect(_on_correct_pair_found)
	evidence_board.board_completed.connect(_on_board_completed)

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("กระดานบอร์ดเก่าๆ ที่ไม่ค่อยได้ใช้แล้ว...")

func start_active_interaction() -> void:
	var evidence_board = get_tree().get_first_node_in_group("EvidenceBoard")

	if evidence_board:
		evidence_board.open()
		QuestManager.complete_objective("back_to_office", "back_to_office1")
	else:
		print("EvidenceBoard not found")

func start_completed_interaction() -> void:
	var evidence_board = get_tree().get_first_node_in_group("EvidenceBoard")

	if evidence_board:
		evidence_board.open()
	else:
		print("EvidenceBoard not found")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)

func dialogic_signal(argument: String) -> void:
	pass

func _on_correct_pair_found(card_a: String, card_b: String) -> void:
	print("Correct pair: ", card_a, " + ", card_b)

	match [card_a, card_b]:
		["C1", "C8"], ["C8", "C1"]:
			DialogueManager.show_short_message("Ingrid ส่งเอกสารบัญชีที่ผิดปกติ KONS 7-B ให้ Victor ")

		["C1", "C9"], ["C9", "C1"]:
			DialogueManager.show_short_message("KONS 7-B Conrad รู้จักและจำเลขบัญชีนี้ได้ทันที ทั้งๆ ที่เขาเป็นหัวหน้าซึ่งไม่จำเป็นต้องมายุ่งเกี่ยวกับบัญชีด้วยซ้ำ")

		["C3", "C11"], ["C11", "C3"]:
			DialogueManager.show_short_message("เศษตะกอนที่เจอในแก้วบริเวณสถานที่เกิดเหตุ ผลการวิเคราะห์ Harder บอกว่าเป็นสารพิษ Aconitine ซึ่งจะส่งผลให้หัวใจล้มเหลวและนี้ก็เป็นสาเหตุการเสียชีวิตของ Victor")
			
		["C4", "C10"], ["C10", "C4"]:
			DialogueManager.show_short_message("Conrad จำชื่อของ Elias/Ingrid ได้ทันทีซึ่งทั้ง 2 คนโดนไล่ออกเมื่อ 3 ปีที่แล้วและมีรายชื่ออยู่ในแฟ้มของ Victor ที่เจอบริเวณสถานที่เกิดเหตุ")

		["C5", "C6"], ["C6", "C5"]:
			DialogueManager.show_short_message("Garret บอกว่าได้กลิ่นควันที่บริเวณบันได้ซึ่งก็ไปเจอเป็นบุหรี่ยี่ห้อ Novik ที่ถูกทิ้งจากหน้าต่างห้องควบคุม")

		["C6", "C12"], ["C12", "C6"]:
			DialogueManager.show_short_message("คนร้ายไปซื้อสมุนไพรมีพิษจากร้าน Halloway ซึ่งมีการสูบบุหรี่ก่อนเข้าร้าน และคาดว่าบุหรี่ที่คนร้ายสูบหน้าร้านจะเป็นยี่ห้อ Norvik")
			
		["C11", "C12"], ["C12", "C11"]:
			DialogueManager.show_short_message("คนร้ายใช้สารพิษ Aconitine ที่สกัดได้จากพืชที่มีชื่อว่า Monkshood ซึ่งสามารถหาซื้อได้จากร้าน Holloway")
			
func _on_board_completed() -> void:
	DialogueManager.show_short_message("หลักฐานทุกอย่างพร้อมแล้ว คนร้ายตัวจริงที่อยู่เบิ้องหลังการวางยา Victor คือ Conrad")
	QuestManager.complete_objective("find_criminal", "find_criminal1")
	QuestManager.start_quest("final_quest")
	
	
