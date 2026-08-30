extends Node

signal quest_started(quest: Quest)
signal objective_completed(quest: Quest, objective: QuestObjective)
signal quest_completed(quest: Quest)

var current_quest: Quest
var active_quests: Dictionary = {}
var completed_quests: Dictionary = {}

enum QuestState {
	NOT_STARTED,
	ACTIVE,
	COMPLETED
}

var objective_states: Dictionary = {}

# เก็บ Quest ทั้งหมด
# {
#     "quest_id": Quest Resource
# }
var all_quests: Dictionary = {}


func _ready() -> void:
	load_quests()


# =========================================================
# Quest Loading
# =========================================================

func load_quests() -> void:
	var dir := DirAccess.open("res://data/quests/")

	if dir == null:
		print("Quest folder not found")
		return

	for file_name in dir.get_files():
		if not file_name.ends_with(".tres"):
			continue

		var path := "res://data/quests/" + file_name
		var quest := load(path) as Quest

		if quest == null:
			continue

		all_quests[quest.quest_id] = quest

	print("Loaded Quests: ", all_quests.size())


# =========================================================
# Quest Manager
# =========================================================

func start_quest(quest_id: String) -> void:
	if not all_quests.has(quest_id):
		print("Quest not found: ", quest_id)
		return

	if active_quests.has(quest_id):
		return

	if completed_quests.has(quest_id):
		return

	var quest: Quest = all_quests[quest_id]

	current_quest = quest
	active_quests[quest_id] = quest

	var states: Dictionary = {}

	for objective in quest.objectives:
		states[objective.objective_id] = false

	objective_states[quest_id] = states

	print("Quest Started: ", quest.quest_name)

	quest_started.emit(quest)


func complete_objective(
	quest_id: String,
	objective_id: String
) -> void:

	if not active_quests.has(quest_id):
		return

	if not objective_states.has(quest_id):
		return

	var states: Dictionary = objective_states[quest_id]

	if not states.has(objective_id):
		return

	if states[objective_id]:
		return

	states[objective_id] = true

	var quest: Quest = active_quests[quest_id]
	var objective: QuestObjective = null

	for obj in quest.objectives:
		if obj.objective_id == objective_id:
			objective = obj
			break

	if objective == null:
		print("Objective not found: ", objective_id)
		return

	print("Objective Completed: ", objective.description)

	objective_completed.emit(quest, objective)

	_check_quest_completed(quest_id)


# =========================================================
# Quest Completion
# =========================================================

func _check_quest_completed(quest_id: String) -> void:
	if not objective_states.has(quest_id):
		return

	var states: Dictionary = objective_states[quest_id]

	for objective_id in states:
		if not states[objective_id]:
			return

	var quest: Quest = active_quests[quest_id]

	print("Quest Completed: ", quest.quest_name)

	completed_quests[quest_id] = quest

	active_quests.erase(quest_id)

	if current_quest == quest:
		current_quest = null

	quest_completed.emit(quest)

# =========================================================
# Get Functions
# =========================================================

func is_objective_completed(
	quest_id: String,
	objective_id: String
) -> bool:

	if not objective_states.has(quest_id):
		return false

	return objective_states[quest_id].get(objective_id, false)


func is_quest_completed(quest_id: String) -> bool:
	return completed_quests.has(quest_id)


func get_quest_state(quest_id: String) -> QuestState:
	if completed_quests.has(quest_id):
		return QuestState.COMPLETED

	if active_quests.has(quest_id):
		return QuestState.ACTIVE

	return QuestState.NOT_STARTED
