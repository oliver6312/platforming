extends Node


const SAVE_PATH = "user://undergrowthsavegame.json"

func save_game():
	var save_data = {
		"unlocked_abilities": GameManager.unlocked_abilities
	}
	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)
	
	if file:
		file.store_string(JSON.stringify(save_data))
