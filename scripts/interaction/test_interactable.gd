extends Interactable

@export var test_quest: Quest

func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)
	
func start_valid_interaction():
	player.set_movement_enabled(false)
	
	print("ตรวจสอบ : ", name)
	Dialogic.start("testtimeline")
	Dialogic.timeline_ended.connect(ended)
		
func start_invalid_interaction():
	print("invalid interaction : " + name)

func DialogicSignal(argument:String):
	if argument == "quest":
		QuestManager.start_quest(test_quest)
