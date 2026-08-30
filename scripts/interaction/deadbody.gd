extends Interactable

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ยังอุ่นอยู่ น่าจะเสียชีวิตได้ไม่นาน ...")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("check_body")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("ไม่เหลืออะไรให้ตรวจสอบแล้ว สำรวจอย่างอื่นต่อ ...")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	player.set_movement_enabled(true)
	EvidenceManager.unlock_evidence("C1")
	EvidenceManager.unlock_evidence("C2")
	QuestManager.complete_objective("check_body", "check_body_1")
	QuestManager.start_quest("explore_room1")
