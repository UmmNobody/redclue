extends Node

signal room_changed

var phone_ring_played: bool = false

# Teleport
var pending_teleport: bool = false
var current_location_id: String = ""

var triggered_events: Dictionary = {}

func restart_game_manager() -> void:
	phone_ring_played = false
	triggered_events.clear()

func change_location(location_id: String) -> void:
	var scene_path := LocationManager.get_location_scene(location_id)

	if scene_path.is_empty():
		print("Invalid Location: ", location_id)
		return

	if not LocationManager.is_location_unlocked(location_id):
		print("Location Locked: ", location_id)
		return

	current_location_id = location_id
	pending_teleport = true

	get_tree().change_scene_to_file(scene_path)

func check_and_register_event(event_id: String) -> bool:
	# เคย Trigger Event นี้แล้ว
	if triggered_events.has(event_id):
		return false

	# ยังไม่เคย Trigger → บันทึกชื่อไว้
	triggered_events[event_id] = true
	return true

func restart_game() -> void:
	GameManager.restart_game_manager()
	QuestManager.restart_quest_manager()
	EvidenceManager.restart_evidence_manager()
	LocationManager.restart_location_manager()
