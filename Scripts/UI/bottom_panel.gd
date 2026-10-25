class_name BattlePanel extends Control

@export var monster_info: RichTextLabel

@export var move_button_1: Button
@export var move_button_2: Button
@export var move_button_3: Button
@export var move_button_4: Button

var active_monster: Monster

func _ready() -> void:
	# TODO: listen for events to connect and update the monster

	Events.start_active_monster_turn.connect(handle_active_monster_ui)
	return

func _on_leave_button_pressed() -> void:
	Events.request_quit.emit()

func _on_log_button_pressed() -> void:
	Events.request_log.emit()

func handle_active_monster_ui(active_monster: Monster):
	monster_info.text = active_monster.dump_state()
	move_button_1.disabled = false 
	move_button_2.disabled = false 
	move_button_3.disabled = false 
	move_button_4.disabled = false 
	move_button_1.hide()
	move_button_2.hide()
	move_button_3.hide()
	move_button_4.hide()
	if active_monster.moves.size() >= 1:
		var move_1 = active_monster.moves[0]
		move_button_1.visible = true
		move_button_1.text = move_1.name
		if !active_monster.moves[0].rank[active_monster.battle_position]:
			move_button_1.disabled = true

	if active_monster.moves.size() >= 2:
		var move_2 = active_monster.moves[1]
		move_button_2.visible = true
		move_button_2.text = move_2.name
		if !active_monster.moves[1].rank[active_monster.battle_position]:
			move_button_2.disabled = true

	if active_monster.moves.size() >= 3:
		var move_3 = active_monster.moves[2]
		move_button_3.visible = true
		move_button_3.text = move_3.name
		if !active_monster.moves[2].rank[active_monster.battle_position]:
			move_button_3.disabled = true

	if active_monster.moves.size() >= 4:
		var move_4 = active_monster.moves[3]
		move_button_4.visible = true
		move_button_4.text = move_4.name
		if !active_monster.moves[3].rank[active_monster.battle_position]:
			move_button_4.disabled = true

func _on_move_button_1_pressed() -> void:
	Events.move_button_pressed.emit(0)

func _on_move_button_2_pressed() -> void:
	Events.move_button_pressed.emit(1)

func _on_move_button_3_pressed() -> void:
	Events.move_button_pressed.emit(2)

func _on_move_button_4_pressed() -> void:
	Events.move_button_pressed.emit(3)
#	Events.request_move_by_index.emit(3)
#	if GameRunner.target_selection_mode:
#		pass
#	GameRunner.end_turn()
