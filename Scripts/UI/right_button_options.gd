class_name BattlePanel extends Control

@export var monster_info: RichTextLabel

var selected_monster: Monster

func _ready() -> void:
	# TODO: listen for events to connect and update the monster

	Events.monster_selected_by_player.connect(show_selected_monster_stats)
	return

func _on_leave_button_pressed() -> void:
	Events.request_quit.emit()

func show_selected_monster_stats(selected_monster: Monster):
	monster_info.text = selected_monster.dump_state()
