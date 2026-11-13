extends Panel

func _ready() -> void:
	Events.game_over.connect(handle_game_over)
	
func handle_game_over(_win: bool):
	self.show()

func _on_button_pressed() -> void:
	Events.request_end_battle.emit()
