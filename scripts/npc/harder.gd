extends Interactable

@export var npc_position: Marker2D = null

func _ready() -> void:
	if QuestManager.is_quest_completed("meet_conrad2"):
		global_position = npc_position.global_position
		

func start_not_started_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("หมอนิติเวช Harder")

func start_active_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("harder1")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("หมอนิติเวช Harder")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	Dialogic.signal_event.disconnect(dialogic_signal)
	player.set_movement_enabled(true)
	# Override me

func dialogic_signal(argument: String) :
	if argument == "get_evidence_c11":
		LocationManager.unlock_location("halloway")
		EvidenceManager.unlock_evidence("C11")
		QuestManager.complete_objective("meet_harder", "meet_harder1")
		QuestManager.start_quest("meet_petch")
