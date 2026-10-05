extends VBoxContainer


func _on_leave_button_pressed() -> void:
	Events.request_quit.emit()
