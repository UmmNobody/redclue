class_name NPCPositionController
extends Node


func _ready() -> void:
	GameManager.room_changed.connect(_on_room_changed)
	_update_position()


func _on_room_changed() -> void:
	_update_position()


func _update_position() -> void:
	var latest_position: NPCQuestPosition = null
	var latest_order: int = -1

	for child in get_children():
		if not child is NPCQuestPosition:
			continue

		var position_data: NPCQuestPosition = child

		if position_data.position_marker == null:
			continue

		# Quest นี้ยังไม่ Complete
		if not QuestManager.completed_quests.has(position_data.quest_id):
			continue

		var quest: Quest = QuestManager.all_quests.get(
			position_data.quest_id
		)

		if quest == null:
			continue

		# เลือก Quest ที่มี order สูงที่สุด
		if quest.quest_order > latest_order:
			latest_order = quest.quest_order
			latest_position = position_data

	if latest_position == null:
		return

	var npc := get_parent()

	if npc is Node2D:
		npc.global_position = latest_position.position_marker.global_position

		print(
			"NPC position changed: ",
			latest_position.quest_id
		)
