extends Control

func _ready() -> void:
	self.hide()
	Events.request_open_option_menu.connect(show_option_menu)

func show_option_menu():
	print("show menu")
	self.show()

func _on_button_close_pressed() -> void:
	self.hide()

func _on_button_save_pressed() -> void:
	pass # Replace with function body.

func _on_button_leave_pressed() -> void:
	Events.request_quit.emit()
