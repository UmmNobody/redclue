extends Control

@onready var quest_page: Control = $QuestPage
@onready var evidence_page: Control = $EvidencePage

@onready var quest_tab: Button = $QuestTab
@onready var evidence_tab: Button = $EvidenceTab

@onready var quest_title: Label = $QuestPage/QuestTitle
@onready var quest_description: RichTextLabel = $QuestPage/QuestDescription

@onready var evidence_grid: GridContainer = $EvidencePage/EvidenceGrid
@onready var previous_button: Button = $EvidencePage/PreviousButton
@onready var next_button: Button = $EvidencePage/NextButton
@onready var page_label: Label = $EvidencePage/PageLabel

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var current_page := 0
const EVIDENCES_PER_PAGE := 4

func _ready() -> void:
	hide()

	quest_tab.pressed.connect(_show_quest_page)
	evidence_tab.pressed.connect(_show_evidence_page)
	previous_button.pressed.connect(_previous_evidence_page)
	next_button.pressed.connect(_next_evidence_page)

	_show_quest_page()

# Notebook

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("notebook"):
		toggle_notebook()

func toggle_notebook() -> void:
	if visible:
		close_notebook()
	else:
		open_notebook()

func open_notebook() -> void:
	refresh()
	refresh_evidence()
	show()
	
	player.set_movement_enabled(false)

func close_notebook() -> void:
	hide()
	
	player.set_movement_enabled(true)

func refresh() -> void:
	var quest: Quest = QuestManager.current_quest

	if quest == null:
		quest_title.text = "ไม่มีเควส"
		quest_description.text = ""
		return

	quest_title.text = quest.quest_name

	var description_text: String = quest.description

	if not quest.objectives.is_empty():
		description_text += "\n\n"

		for objective in quest.objectives:
			description_text += create_objective(quest, objective)
			description_text += "\n"

	quest_description.text = description_text


func create_objective(
	quest: Quest,
	objective: QuestObjective
) -> String:
	var completed := QuestManager.is_objective_completed(
		quest.quest_id,
		objective.objective_id
	)

	if completed:
		return "[s]" + objective.description + "[/s]"
	
	return objective.description

func _on_close_button_pressed() -> void:
	close_notebook()

# Quest & Evidence Page

func _show_quest_page() -> void:
	quest_page.show()
	evidence_page.hide()


func _show_evidence_page() -> void:
	quest_page.hide()
	evidence_page.show()


func _previous_evidence_page() -> void:
	if current_page <= 0:
		return

	current_page -= 1
	refresh_evidence()

func _next_evidence_page() -> void:
	var evidences := EvidenceManager.get_unlocked_evidences()

	var max_page := ceili(
		float(evidences.size()) / EVIDENCES_PER_PAGE
	) - 1

	if current_page >= max_page:
		return

	current_page += 1
	refresh_evidence()
	
func refresh_evidence() -> void:
	clear_evidence()

	var evidences := EvidenceManager.get_unlocked_evidences()

	if evidences.is_empty():
		page_label.text = "ไม่มีหลักฐาน"
		previous_button.disabled = true
		next_button.disabled = true
		return

	var start_index := current_page * EVIDENCES_PER_PAGE
	var end_index : int = min(
		start_index + EVIDENCES_PER_PAGE,
		evidences.size()
	)

	for i in range(start_index, end_index):
		var card := preload(
			"res://scenes/ui/evidence_card.tscn"
		).instantiate()

		evidence_grid.add_child(card)
		card.setup(evidences[i])

	var total_pages := ceili(
		float(evidences.size()) / EVIDENCES_PER_PAGE
	)

	page_label.text = "%d / %d" % [
		current_page + 1,
		total_pages
	]

	previous_button.disabled = current_page <= 0
	next_button.disabled = current_page >= total_pages - 1
	
func clear_evidence() -> void:
	for child in evidence_grid.get_children():
		child.queue_free()
