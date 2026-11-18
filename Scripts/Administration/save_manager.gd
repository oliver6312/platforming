extends Node

const SAVE_PATH = "user://undergrowthsavegame.json"

func save_game():
	print("game is saved")
	var save_data = {
		"unlocked_abilities": GameManager.unlocked_abilities,
		"player_location": GameManager.player_location,
		"player_monsters": GameManager.get_monster_save_data()
	}
	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)
	
	if file:
		file.store_string(JSON.stringify(save_data))

func load_data():
	print("game is loaded")
	if not FileAccess.file_exists(SAVE_PATH):
		print("no data saved")
		return
	print("loading data")
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
	GameManager.player_location = save_data.get(
		"player_location",
		GameManager.player_location
	)
	GameManager.load_monster_save_data(
		save_data.get("player_monsters", {})
	)
