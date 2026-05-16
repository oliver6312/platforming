extends CharacterBody2D

@export_group("Horizontal")
@export var run_speed := 400.0
@export var acceleration := 1800.0
@export var air_acceleration := 1300.0
@export var friction := 6000.0
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

var locked_action := ""
var movement_locked := false
var animation_locked := false
var direction_locked := false


@onready var spear_hitbox_up: Area2D = %SpearHitboxUp
@onready var right_up_spear: CollisionShape2D = %RightUpSpear
@onready var left_up_spear: CollisionShape2D = %LeftUpSpear
@onready var spear_hitbox_down: Area2D = %SpearHitboxDown
@onready var right_down_spear: CollisionShape2D = %RightDownSpear
@onready var left_down_spear: CollisionShape2D = %LeftDownSpear
@onready var spear_hitbox_side: Area2D = %SpearHitboxSide
@onready var right_side_spear: CollisionShape2D = %RightSideSpear
@onready var left_side_spear: CollisionShape2D = %LeftSideSpear



@export var spear_recoil_force := 700.0
var attack_has_recoiled := false

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

	spear_hitbox_up.body_entered.connect(_on_spear_hitbox_body_entered)
	spear_hitbox_down.body_entered.connect(_on_spear_hitbox_body_entered)
	spear_hitbox_side.body_entered.connect(_on_spear_hitbox_body_entered)

	disable_all_right_hitbox()
	disable_all_left_hitbox()

	spear_hitbox_up.monitoring = false
	spear_hitbox_down.monitoring = false
	spear_hitbox_side.monitoring = false

func disable_all_right_hitbox() -> void:
	right_up_spear.disabled = true
	right_down_spear.disabled = true
	right_side_spear.disabled = true

func enable_all_right_hitbox() -> void:
	right_up_spear.disabled = false
	right_down_spear.disabled = false
	right_side_spear.disabled = false

func disable_all_left_hitbox() -> void:
	left_up_spear.disabled = true
	left_down_spear.disabled = true
	left_side_spear.disabled = true

func enable_all_left_hitbox() -> void:
	left_up_spear.disabled = false
	left_down_spear.disabled = false
	left_side_spear.disabled = false

func _physics_process(delta: float) -> void:
	var input_axis := Input.get_axis("ui_left", "ui_right")

	if input_axis != 0 and not direction_locked:
		facing = sign(input_axis)

	handle_attack()
	update_timers(delta)

	if not movement_locked:
		handle_dash(delta, input_axis)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	if dash_timer <= 0.0:
		handle_horizontal_movement(delta, input_axis)
		handle_jump()
		apply_gravity(delta)
		handle_wall_slide()

	move_and_slide()

	if dash_timer > 0.0 and is_on_floor() and dash_direction.y > 0.0:
		dash_timer = 0.0
		velocity.x = 0.0

	apply_corner_correction()
	player_visuals(input_axis)

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
	if movement_locked:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		return

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
			dash_cooldown_timer = 0.0
		else:
			dash_cooldown_timer = dash_cooldown
		if x_dir == 0:
			x_dir = facing

		dash_direction = Vector2(x_dir, 0.5).normalized()
		dash_timer = dash_time
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

func player_visuals(input_axis: float) -> void:
	if not direction_locked:
		if input_axis < 0:
			animated_sprite_2d.flip_h = true
			enable_all_left_hitbox()
			disable_all_right_hitbox()
			
		elif input_axis > 0:
			animated_sprite_2d.flip_h = false
			enable_all_right_hitbox()
			disable_all_left_hitbox()

	if animation_locked:
		return

	if input_axis != 0 and is_on_floor():
		animated_sprite_2d.play("run")
	elif is_on_wall() and not is_on_floor():
		animated_sprite_2d.play("wall_one_frame")
	elif not is_on_wall() and not is_on_floor() and velocity.y < 0:
		animated_sprite_2d.play("jump_up")
	elif not is_on_wall() and not is_on_floor() and velocity.y > 0:
		animated_sprite_2d.play("jump_down")
	elif input_axis == 0 and is_on_floor():
		animated_sprite_2d.play("idle")

func handle_attack() -> void:
	if Input.is_action_just_pressed("attack") and locked_action == "":
		locked_action = "attack"
		movement_locked = true
		animation_locked = true
		direction_locked = true
		attack_has_recoiled = false
		spear_hitbox_side.monitoring = true 

		velocity.x = 0.0
		animated_sprite_2d.play("attack_ground_spear_sideways") 

func _on_spear_hitbox_body_entered(body: Node2D) -> void:
	if locked_action != "attack":
		return

	if attack_has_recoiled:
		return

	if body.is_in_group("spear_recoil"):
		attack_has_recoiled = true
		print("hit the object")

		var recoil_direction := -facing
		velocity.x = recoil_direction * spear_recoil_force

func _on_animation_finished() -> void:
	if locked_action == "attack":
		locked_action = ""
		movement_locked = false
		animation_locked = false
		direction_locked = false
		
		spear_hitbox_side.monitoring = false
#		right_spear.disabled = true
#		left_spear.disabled = true
		right_up_spear.disabled = true
		right_down_spear.disabled = true
#		spear_hitbox.monitoring = false
