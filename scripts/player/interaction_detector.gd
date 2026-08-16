class_name InteractionDetector
extends Node2D

signal target_changed(new_target: Interactable)

@export_category("Interaction")
@export var interaction_range: float = 100.0

var current_target: Interactable = null

func _physics_process(_delta: float) -> void:
	update_target()

	if Input.is_action_just_pressed("interact"):
		print("tried to interact")
		interact_with_target()

# =========================================
# Find Target
# =========================================

func update_target() -> void:
	var player := get_parent()
	if not player.has_method("get_facing_direction"):
		return

	var facing_direction: int = player.get_facing_direction()
	var closest_target: Interactable = null
	var closest_distance: float = INF

	for node in get_tree().get_nodes_in_group("Interactable"):
		if not node is Interactable:
			continue
		var target: Interactable = node

		# Distance
		var distance: float = global_position.distance_to(
			target.global_position
		)
		
		if distance > interaction_range:
			continue

		# Facing Direction
		var direction_to_target := (
			target.global_position.x - global_position.x
		)

		if facing_direction == 1 and direction_to_target < 0:
			continue
		if facing_direction == -1 and direction_to_target > 0:
			continue

		# Closest Target
		if distance < closest_distance:
			closest_distance = distance
			closest_target = target

	# -----------------------------------------
	# Target Changed
	# -----------------------------------------

	if closest_target != current_target:
		var previous_target := current_target
		current_target = closest_target
		
		# Remove highlight from old target
		if previous_target != null:
			previous_target.set_highlight(false)
		# Add highlight to new target
		if current_target != null:
			current_target.set_highlight(true)
		
		target_changed.emit(current_target)

# =========================================
# Interact
# =========================================

func interact_with_target() -> void:
	if current_target == null:
		return

	var player := get_parent()
	current_target.interact(player)
