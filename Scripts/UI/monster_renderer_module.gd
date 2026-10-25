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

func connect_events() -> void:
	Events.on_new_game_state_created.connect(get_controller_components)
	Events.on_monster_added_to_battle.connect(maybe_bind_monster)
	Events.on_monster_updated.connect(maybe_update_monster)
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

func check_active_monster(selected_monster: Monster):
	if selected_monster == bound_monster:
		selected = true
		selection_symbol.visible = true
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
	if !belongs_to_player:
		sprite.flip_h = true

	name_label.text = bound_monster.name.to_upper()
	sprite.texture = bound_monster.image
#	status_label.text = bound_monster.get_condition_string()
	hp_bar.max_value = bound_monster.max_hp
	hp_bar.value = bound_monster.current_hp
	hp_label.text = "{hp}\\{max_hp}".format({"hp": bound_monster.current_hp, "max_hp": bound_monster.species.base_max_hp})
	
	bound_monster.battle_position = monster_position
	
	target_sprite.visible = false
	monster_button.disabled = false
	return

func check_available_target(pressed_move: Move):
	target_sprite.visible = true
	monster_button.disabled = false
	var target = pressed_move.target
	if battle_state.all_opponent_monsters.has(battle_state.active_monster):
		if !belongs_to_player or !target[monster_position]:
				target_sprite.visible = false
				monster_button.disabled = true
	else:
		if belongs_to_player or !target[monster_position]:
				target_sprite.visible = false
				monster_button.disabled = true
	if pressed_move.target_self_only and bound_monster != battle_state.active_monster:
		target_sprite.visible = false
		monster_button.disabled = true
	if pressed_move.target_self_only and bound_monster == battle_state.active_monster:
		target_sprite.visible = true
		monster_button.disabled = false

func _on_button_pressed() -> void:
	if GameRunner.target_selection_mode:
		Events.request_target_monster.emit(bound_monster)
		GameRunner.end_turn()
