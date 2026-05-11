extends CharacterBody2D

@export var max_speed := 220.0
@export var ground_accel := 1800.0
@export var ground_decel := 2200.0
@export var air_accel := 1200.0

@export var jump_velocity := -420.0
@export var gravity_up := 900.0
@export var gravity_down := 1500.0
@export var jump_cut_multiplier := 0.45

@export var coyote_time := 0.1
@export var jump_buffer_time := 0.12

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

func _physics_process(delta):
	var input_dir := Input.get_axis("move_left", "move_right")

	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	var accel := ground_accel if is_on_floor() else air_accel

	if input_dir != 0:
		velocity.x = move_toward(velocity.x, input_dir * max_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ground_decel * delta)

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0
		coyote_timer = 0

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	if velocity.y < 0:
		velocity.y += gravity_up * delta
	else:
		velocity.y += gravity_down * delta

	move_and_slide()
