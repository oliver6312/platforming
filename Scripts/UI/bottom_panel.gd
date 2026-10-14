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
	active_monster.move_one
	

func _on_move_button_pressed() -> void:
	GameRunner.end_turn()
