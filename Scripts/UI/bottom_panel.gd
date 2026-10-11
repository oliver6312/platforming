class_name BattlePanel extends Control

@export var monster_info: RichTextLabel

var selected_monster: Monster

func _ready() -> void:
	# TODO: listen for events to connect and update the monster

	Events.start_active_monster_turn.connect(show_active_monster_stats)
	return

func _on_leave_button_pressed() -> void:
	Events.request_quit.emit()

func _on_log_button_pressed() -> void:
	Events.request_log.emit()

func show_active_monster_stats(selected_monster: Monster):
	monster_info.text = selected_monster.dump_state()

func _on_move_button_pressed() -> void:
	GameRunner.end_turn()
