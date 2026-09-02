extends CharacterBody2D

@export_category("Movement")
@export var move_speed: float = 200.0

var facing_direction: int = 1
var can_move: bool = true

var footstep_timer: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.3


func _ready() -> void:
	$AnimatedSprite2D.play("idle")


func _physics_process(delta: float) -> void:
	if can_move:
		handle_movement()
	else:
		velocity.x = 0
		reset_footstep()

	move_and_slide()

	if can_move and velocity.x != 0:
		$AnimatedSprite2D.play("walk")
		handle_footstep(delta)
	else:
		$AnimatedSprite2D.play("idle")
		reset_footstep()


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
		reset_footstep()

	$AnimatedSprite2D.play("idle")


# Footstep
func handle_footstep(delta: float) -> void:
	footstep_timer -= delta

	if footstep_timer <= 0.0:
		SfxManager.play_sfx("footstep")
		footstep_timer = FOOTSTEP_INTERVAL


func reset_footstep() -> void:
	footstep_timer = 0.0
