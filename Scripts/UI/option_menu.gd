extends Control

func _ready() -> void:
	self.hide()
	Events.request_open_option_menu.connect(show_option_menu)

func show_option_menu():
	print("show menu")
	self.show()

func _on_button_pressed() -> void:
	self.hide()
