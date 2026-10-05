class_name BattlePanel extends Control

func _on_leave_button_pressed() -> void:
	Events.request_quit.emit()
