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
	move_button_1.hide()
	move_button_2.hide()
	move_button_3.hide()
	move_button_4.hide()
	if active_monster.moves.size() >= 1:
		var move_1 = active_monster.moves[0]
		move_button_1.visible = true
		move_button_1.text = move_1.name
	if active_monster.moves.size() >= 2:
		var move_2 = active_monster.moves[1]
		move_button_2.visible = true
		move_button_2.text = move_2.name
	if active_monster.moves.size() >= 3:
		var move_3 = active_monster.moves[2]
		move_button_3.visible = true
		move_button_3.text = move_3.name
	if active_monster.moves.size() >= 4:
		var move_4 = active_monster.moves[3]
		move_button_4.visible = true
		move_button_4.text = move_4.name


func _on_move_button_1_pressed() -> void:
#	Events.request_move_by_index.emit(0)
	GameRunner.chosen_move_index = 0
	GameRunner.target_selection_mode = true

func _on_move_button_2_pressed() -> void:
	GameRunner.chosen_move_index = 1
	GameRunner.target_selection_mode = true
#	Events.request_move_by_index.emit(1)
#	if GameRunner.target_selection_mode:
#		pass
#	GameRunner.end_turn()


func _on_move_button_3_pressed() -> void:
	GameRunner.chosen_move_index = 2
	GameRunner.target_selection_mode = true
#	Events.request_move_by_index.emit(2)
#	if GameRunner.target_selection_mode:
#		pass
#	GameRunner.end_turn()


func _on_move_button_4_pressed() -> void:
	GameRunner.chosen_move_index = 3
	GameRunner.target_selection_mode = true
#	Events.request_move_by_index.emit(3)
#	if GameRunner.target_selection_mode:
#		pass
#	GameRunner.end_turn()
