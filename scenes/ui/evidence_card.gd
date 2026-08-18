class_name EvidenceCard
extends Panel

@onready var evidence_image: TextureRect = $EvidenceImage
@onready var evidence_name: Label = $EvidenceName


func setup(evidence: Evidence) -> void:
	evidence_name.text = evidence.evidence_name

	if evidence.image:
		evidence_image.texture = evidence.image
	elif evidence.icon:
		evidence_image.texture = evidence.icon
