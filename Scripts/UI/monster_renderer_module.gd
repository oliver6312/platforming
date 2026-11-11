class_name MonsterRendererModule extends Control

# This is a UI panel that handles all visuals for a monster in the battle, 
# including its sprite, HPbar and name

@export 
var monster_position: int

@export 
var belongs_to_player: bool

@export 
var frame: Control

@export
var data_panel: Control

@export
var name_label: Label

@export
var hp_label: Label

@export 
var hp_bar: ProgressBar

@export
var status_label: Label

@export
var sprite: Sprite2D

@export
var target_sprite: Sprite2D

@export
var monster_button: Button

@export
var selection_symbol: Sprite2D

var bound_monster: Monster
var selected: bool

var battle_state: BattleState
var rng: RandomNumberGenerator

const DAMAGE_LABEL = preload("uid://3t3j40l1nvf2")

func connect_events() -> void:
	Events.on_new_game_state_created.connect(get_controller_components)
	Events.on_monster_added_to_battle.connect(maybe_bind_monster)
	Events.on_monster_updated.connect(maybe_update_monster)
	Events.on_monster_damaged.connect(maybe_damage_monster)
	Events.start_active_monster_turn.connect(check_active_monster)
	Events.update_all_monsters.connect(update)
	Events.chosen_move_target.connect(check_available_target)
	return

func get_controller_components():
	battle_state = GameRunner.battle_state
	rng = GameRunner.rng

func maybe_update_monster(monster: Monster):
	if monster == bound_monster:
		update()
		monster.battle_position = monster_position
		print(monster.name)
		print(monster.battle_position + monster_position)

func maybe_damage_monster(monster: Monster, damage: int, crit: bool, type_advantage_coefficient: float):
	var label_start_position: Vector2 = Vector2(45, -90)
	
	if monster == bound_monster:
		match type_advantage_coefficient:
			0.0:
				var new_element_label = DAMAGE_LABEL.instantiate() as Label
				new_element_label.add_theme_color_override("font_color", Color.DIM_GRAY)
				new_element_label.text = "IMMUNE"
				new_element_label.global_position = global_position + label_start_position
				get_tree().current_scene.call_deferred("add_child", new_element_label)
				await get_tree().create_timer(0.2).timeout
			0.25:
				var new_element_label = DAMAGE_LABEL.instantiate() as Label
				new_element_label.add_theme_color_override("font_color", Color.WHITE_SMOKE)
				new_element_label.text = "SUPER WEAK"
				new_element_label.global_position = global_position + label_start_position
				get_tree().current_scene.call_deferred("add_child", new_element_label)
				await get_tree().create_timer(0.2).timeout
			0.5:
				var new_element_label = DAMAGE_LABEL.instantiate() as Label
				new_element_label.add_theme_color_override("font_color", Color.CORNFLOWER_BLUE)
				new_element_label.text = "WEAK"
				new_element_label.global_position = global_position + label_start_position
				get_tree().current_scene.call_deferred("add_child", new_element_label)
				await get_tree().create_timer(0.2).timeout
			2.0:
				var new_element_label = DAMAGE_LABEL.instantiate() as Label
				new_element_label.add_theme_color_override("font_color", Color.DARK_BLUE)
				new_element_label.text = "STRONG"
				new_element_label.global_position = global_position + label_start_position
				get_tree().current_scene.call_deferred("add_child", new_element_label)
				await get_tree().create_timer(0.2).timeout
			4.0:
				var new_element_label = DAMAGE_LABEL.instantiate() as Label
				new_element_label.add_theme_color_override("font_color", Color.REBECCA_PURPLE)
				new_element_label.text = "SUPER STRONG"
				new_element_label.global_position = global_position + label_start_position
				get_tree().current_scene.call_deferred("add_child", new_element_label)
				await get_tree().create_timer(0.2).timeout

		if crit:
			var new_crit_label = DAMAGE_LABEL.instantiate() as Label
			new_crit_label.add_theme_color_override("font_color", Color(1, 0.5, 0, 1))
			new_crit_label.text = "CRIT"
			new_crit_label.global_position = global_position + label_start_position
			get_tree().current_scene.call_deferred("add_child", new_crit_label)
			await get_tree().create_timer(0.2).timeout

		var new_damage_label = DAMAGE_LABEL.instantiate() as Label

		if damage >= 1:
			new_damage_label.add_theme_color_override("font_color", Color(0, 1, 0, 1))

		new_damage_label.text = str(damage)
		new_damage_label.global_position = global_position + label_start_position
		get_tree().current_scene.call_deferred("add_child", new_damage_label)

func check_active_monster(selected_monster: Monster):
	if selected_monster == bound_monster:
		selected = true
		selection_symbol.visible = true
		if belongs_to_player:
			battle_state.is_player_turn = true
		else:
			battle_state.is_player_turn = false
	else:
		selected = false
		selection_symbol.visible = false

func maybe_bind_monster(monster: Monster, is_player_monster: bool, monster_index: int):
	if belongs_to_player == is_player_monster and monster_position == monster_index:
		bound_monster = monster
#		move_child(frame, 0 if is_player_monster else 1)
		update()

func update():
#	if bound_monster == null:
#		return
	if bound_monster.current_hp == 0:
		sprite.hide()
	if !belongs_to_player:
		sprite.flip_h = true

	name_label.text = bound_monster.name.to_upper()
	sprite.texture = bound_monster.image
#	status_label.text = bound_monster.get_condition_string()
	hp_bar.max_value = bound_monster.max_hp
	hp_bar.value = bound_monster.current_hp
	hp_label.text = "{hp}\\{max_hp}".format({"hp": bound_monster.current_hp, "max_hp": bound_monster.species.base_max_hp})
	status_label.text = bound_monster.get_condition_string()
	status_label.hide()
	
	bound_monster.battle_position = monster_position
	
	target_sprite.visible = false
	monster_button.disabled = false
	return

func check_available_target(pressed_move: Move):
	enable_monster_button()
	var target = pressed_move.target

#checks for special cases first, one by one. 
#here it checks if the monster is defeated
	if !battle_state.all_battle_monsters.has(bound_monster):
		disable_monster_button()
		return

#Here it checks if its only self target
	if pressed_move.target_self_only and bound_monster != battle_state.active_monster:
		disable_monster_button()
		return
	if pressed_move.target_self_only and bound_monster == battle_state.active_monster:
		enable_monster_button()
		return

#Here it checks if its an area of effect targeting move
	if pressed_move.target_area_of_effect:
		if pressed_move.target_ally:
			if battle_state.is_player_turn:
				if !belongs_to_player:
					disable_monster_button()
					print("does not belong to player")
					return
			else:
					if belongs_to_player:
						disable_monster_button()
						print("does belong to player")
						return
			return
		if battle_state.is_player_turn:
			if belongs_to_player:
					disable_monster_button()
					return
		else:
			if !belongs_to_player:
					disable_monster_button()
					return
		return

#Here it checks if its an ally targeting move
	if pressed_move.target_ally:
		if battle_state.is_player_turn:
			if !belongs_to_player or !target[monster_position]:
				disable_monster_button()
				return
		else:
			if belongs_to_player or !target[monster_position]:
				disable_monster_button()
				return
		return

#checks if conditon makes it untargetable
	for condition in bound_monster.conditions:
		if condition.resource.untargetable:
			disable_monster_button()
			return

#if it is not ally targeting, all targeting or self targeting then run generic:
	if battle_state.is_player_turn:
		if belongs_to_player or !target[monster_position]:
				disable_monster_button()
	else:
		if !belongs_to_player or !target[monster_position]:
				disable_monster_button()

func _on_button_pressed() -> void:
	if GameRunner.target_selection_mode:
		Events.request_target_monster.emit(bound_monster)
		GameRunner.end_turn()

func disable_monster_button():
	target_sprite.visible = false
	monster_button.disabled = true
func enable_monster_button():
	target_sprite.visible = true
	monster_button.disabled = false

func _on_monster_button_mouse_entered() -> void:
	monster_data_visibility_switcheroo()
#	for conditions in bound_monster.conditions:
#		

func _on_monster_button_mouse_exited() -> void:
	monster_data_visibility_switcheroo()

func monster_data_visibility_switcheroo():
	if hp_bar.visible == true:
		hp_bar.hide()
		hp_label.hide()
		status_label.show()
	else:
		hp_bar.show()
		hp_label.show()
		status_label.hide()
