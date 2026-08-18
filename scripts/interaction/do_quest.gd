extends Interactable

@export var test_quest: Quest

func start_valid_interaction():
	print("ตรวจสอบ : ", name)
	print("พบรอยเลือดบริเวณหน้าต่าง ได้รับหลักฐานเพิ่มเติม")

	QuestManager.complete_objective(
		"talk_to_police",
		"talk_to_police2"
	)

	EvidenceManager.unlock_evidence("c_01")
	EvidenceManager.unlock_evidence("c_02")
	
func start_invalid_interaction():
	print("รอยเลือดจางๆ : " + name)
