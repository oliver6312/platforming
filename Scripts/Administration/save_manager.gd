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

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		print("loading")
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		
		if file == null:
			return
		
		var save_data = JSON.parse_string(file.get_as_text())
		if typeof(save_data) != TYPE_DICTIONARY:
			return
		GameManager.unlocked_abilities = save_data.get(
			"unlocked_abilities",
			GameManager.unlocked_abilities
		)

	else:
		print("no data saved")
