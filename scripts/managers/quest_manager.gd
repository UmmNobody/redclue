extends Node

signal quest_started(quest: Quest)
signal objective_completed(quest: Quest, objective: QuestObjective)
signal quest_completed(quest: Quest)

var current_quest: Quest
var active_quests: Dictionary = {}
var completed_quests: Dictionary = {}

# Runtime state ของ Objective
# {
#     "quest_id": {
#         "objective_id": true/false
#     }
# }
var objective_states: Dictionary = {}


func start_quest(quest: Quest) -> void:
	if quest == null:
		return
	if active_quests.has(quest.quest_id):
		return
	if completed_quests.has(quest.quest_id):
		return

	current_quest = quest
	active_quests[quest.quest_id] = quest

	var states: Dictionary = {}

	for objective in quest.objectives:
		states[objective.objective_id] = false

	objective_states[quest.quest_id] = states

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
		print("r5")
		return

	print("Objective Completed: ", objective.description)
	objective_completed.emit(quest, objective)
	_check_quest_completed(quest_id)


func _check_quest_completed(quest_id: String) -> void:
	var states: Dictionary = objective_states[quest_id]

	for objective_id in states:
		if not states[objective_id]:
			return

	var quest: Quest = active_quests[quest_id]
	print("Quest Completed: ", quest.quest_name)
	completed_quests[quest_id] = quest

	active_quests.erase(quest_id)
	objective_states.erase(quest_id)
	quest_completed.emit(quest)


func is_objective_completed(
	quest_id: String,
	objective_id: String
) -> bool:

	if not objective_states.has(quest_id):
		return false

	return objective_states[quest_id].get(objective_id, false)
