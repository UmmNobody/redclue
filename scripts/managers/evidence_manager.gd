extends Node

signal evidence_unlocked(evidence: Evidence)

var unlocked_evidences: Dictionary = {}
var all_evidences: Dictionary = {}

func _ready() -> void:
	load_evidences()
	
func load_evidences() -> void:
	var files = DirAccess.get_files_at(
		"res://data/evidences/"
	)
	for file in files:
		if not file.ends_with(".tres"):
			continue
		var path = "res://data/evidences/" + file
		var evidence: Evidence = load(path)
		if evidence:
			all_evidences[evidence.evidence_id] = evidence

	print(all_evidences)

func unlock_evidence(evidence_id: String) -> void:
	if unlocked_evidences.has(evidence_id):
		return
	if not all_evidences.has(evidence_id):
		push_error(
			"Evidence not found: " + evidence_id
		)
		return

	unlocked_evidences[evidence_id] = true
	var evidence: Evidence = all_evidences[evidence_id]
	print("ได้รับหลักฐาน:", evidence.evidence_name)

	evidence_unlocked.emit(evidence)
	
func is_evidence_unlocked(evidence_id: String) -> bool:
	return unlocked_evidences.has(evidence_id)
	
func get_evidence(evidence_id: String) -> Evidence:
	if all_evidences.has(evidence_id):
		return all_evidences[evidence_id]
	return null
	
func get_unlocked_evidences() -> Array[Evidence]:
	var result: Array[Evidence] = []
	for id in unlocked_evidences:
		result.append(
			all_evidences[id]
		)
	return result
