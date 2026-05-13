extends CharacterBody2D

@export_group("Horizontal")
@export var run_speed := 600.0
@export var acceleration := 1800.0
@export var air_acceleration := 1300.0
@export var friction := 3000.0
@export var run_after_time := 2.0

@export_group("Jump")
@export var jump_velocity := -500.0
@export var gravity := 1100.0
@export var fall_gravity_multiplier := 1.55
@export var low_jump_gravity_multiplier := 2.4
@export var max_fall_speed := 700.0
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.12

@export_group("Wall")
@export var wall_slide_speed := 80.0
@export var wall_jump_velocity := Vector2(250.0, -500.0)
@export var wall_coyote_time := 0.12

@export_group("Dash")
@export var dash_speed := 800.0
@export var dash_time := 0.14
@export var dash_cooldown := 1

@export_group("Corner Correction")
@export var corner_correction_pixels := 60

@export_group("Visuals")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var facing := 1
var walking_timer := 0.0
var coyote_timer := 0.0
var wall_coyote_timer := 0.0
var jump_buffer_timer := 0.0

var can_double_jump := true
var can_dash := true
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var dash_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_axis := Input.get_axis("ui_left", "ui_right")

	if input_axis != 0:
		facing = sign(input_axis)

	update_timers(delta)
	handle_dash(delta, input_axis)

	if dash_timer <= 0.0:
		handle_horizontal_movement(delta, input_axis)
		handle_jump()
		apply_gravity(delta)
		handle_wall_slide()

	move_and_slide()
	player_visuals(input_axis)
	apply_corner_correction()
	

func update_timers(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
		can_double_jump = true
		can_dash = true
	else:
		coyote_timer -= delta

	if is_on_wall() and not is_on_floor():
		can_double_jump = true
		can_dash = true
		wall_coyote_timer = wall_coyote_time
	else:
		wall_coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func handle_horizontal_movement(delta: float, input_axis: float) -> void:
	var target_speed = run_speed

	var accel := acceleration if is_on_floor() else air_acceleration

	if input_axis != 0:
		velocity.x = move_toward(velocity.x, input_axis * target_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	

func handle_jump() -> void:
	if jump_buffer_timer <= 0:
		return

	if coyote_timer > 0:
		jump(jump_velocity)
	elif wall_coyote_timer > 0:
		var wall_dir := get_wall_normal().x
		velocity.x = wall_dir * wall_jump_velocity.x
		jump(wall_jump_velocity.y)
	elif can_double_jump:
		can_double_jump = false
		jump(jump_velocity)
		print("double jump")

func jump(force: float) -> void:
	velocity.y = force
	jump_buffer_timer = 0.0
	coyote_timer = 0.0
	wall_coyote_timer = 0.0
	animated_sprite_2d.play("jump")

func apply_gravity(delta: float) -> void:
	if is_on_floor():
		return

	var gravity_scale := 1.0

	if velocity.y > 0:
		gravity_scale = fall_gravity_multiplier
	elif velocity.y < 0 and not Input.is_action_pressed("jump"):
		gravity_scale = low_jump_gravity_multiplier

	velocity.y += gravity * gravity_scale * delta
	velocity.y = min(velocity.y, max_fall_speed)

func handle_wall_slide() -> void:
	if Input.get_axis("ui_left", "ui_right"):
		if is_on_wall() and not is_on_floor() and velocity.y > wall_slide_speed:
			velocity.y = wall_slide_speed

func is_wall_sliding() -> bool:
	return is_on_wall() and not is_on_floor() and velocity.y > 0

func handle_dash(delta: float, input_axis: float) -> void:
	if dash_timer > 0:
		dash_timer -= delta
		velocity = dash_direction * dash_speed
		return

	if Input.is_action_just_pressed("dash") and can_dash and dash_cooldown_timer <= 0:
		var x_dir := input_axis
		
		if is_wall_sliding():
			x_dir = get_wall_normal().x
		if x_dir == 0:
			x_dir = facing

		dash_direction = Vector2(x_dir, 0.5).normalized()
		dash_timer = dash_time
		dash_cooldown_timer = dash_cooldown
		can_dash = false
		velocity = dash_direction * dash_speed
		print("dash")


func apply_corner_correction() -> void:
	if velocity.y >= 0:
		return

	if not is_on_ceiling():
		return

	for i in range(1, corner_correction_pixels + 1):
		for side in [-1, 1]:
			var offset := Vector2(i * side, 0)
			if test_move(global_transform.translated(offset), Vector2.UP):
				continue

			global_position.x += offset.x
			return

func player_visuals(input_axis) -> void:

	if input_axis < 0:
		animated_sprite_2d.flip_h = true
	elif input_axis > 0:
		animated_sprite_2d.flip_h = false


	if input_axis != 0 and is_on_floor() == true:
		animated_sprite_2d.play("run")

	if is_on_wall() == true and is_on_floor() == false:
		animated_sprite_2d.play("wall_one_frame")

	if is_on_wall() == false and is_on_floor() == false and velocity.y < 0:
		animated_sprite_2d.play("jump_up")
	if is_on_wall() == false and is_on_floor() == false and velocity.y > 0:
		animated_sprite_2d.play("jump_down")

	if input_axis == 0 and is_on_floor() == true:
		animated_sprite_2d.play("idle")
