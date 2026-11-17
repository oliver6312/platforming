extends Panel

@onready var label: Label = $Label

func _ready() -> void:
	Events.game_over.connect(handle_game_over)
	
func handle_game_over(win: bool):
	if win:
		label.text = "you win"
	else:
		label.text = "you lose"
	self.show()

func _on_button_pressed() -> void:
	SaveManager.save_game()
	Events.request_end_battle.emit()
