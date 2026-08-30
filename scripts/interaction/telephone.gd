extends Interactable

func _ready() -> void:
	if not GameManager.phone_ring_played:
			print("play ring phone ... tudu tudu ...")
			GameManager.phone_ring_played = true

func start_not_started_interaction() -> void:
	set_start_dialogue()
	Dialogic.start("first_phone")
	LocationManager.unlock_location("factory")

func start_active_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("โทรศัพท์บ้านเก่าๆ เครื่องหนึ่ง ...")

func start_completed_interaction() -> void:
	set_start_dialogue()
	DialogueManager.show_short_message("โทรศัพท์บ้านเก่าๆ เครื่องหนึ่ง ...")

func ended() -> void:
	Dialogic.timeline_ended.disconnect(ended)
	QuestManager.start_quest("meet_enmund")
	player.set_movement_enabled(true)
	# Override me
