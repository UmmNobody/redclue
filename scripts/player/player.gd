extends CharacterBody2D

@export_category("Movement")
@export var move_speed: float = 200.0

var facing_direction: int = 1
var can_move: bool = true

func _physics_process(_delta: float) -> void:
	if can_move:
		handle_movement()
	else:
		velocity.x = 0
	move_and_slide()


# Movement
func handle_movement() -> void:
	var direction := Input.get_axis(
		"move_left",
        "move_right"
	)
	if direction != 0:
		velocity.x = direction * move_speed

		update_facing_direction(direction)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			move_speed
		)


# Facing Direction
func update_facing_direction(direction: float) -> void:
	if direction > 0:
		facing_direction = 1
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		facing_direction = -1
		$AnimatedSprite2D.flip_h = true


# Get Facing Direction
func get_facing_direction() -> int:
	return facing_direction

# Movement Control
func set_movement_enabled(enabled: bool) -> void:
	can_move = enabled

	if not enabled:
		velocity.x = 0
