extends Node

###player position
var player_location: Dictionary = {
	"entrance": 0,
	"player_room": "HomeRoom",
	"player_position": Vector2(3,16)
}

var battle_return: bool

###player unlocks
var unlocked_abilities: Dictionary = {
	"dash": false,
	"wall_jump": false,
	"double_jump": false
}

var monster1: Monster
var monster2: Monster
var monster3: Monster

var player_monsters: Dictionary = {
	"player_monster_1": null,
	"player_monster_2": null,
	"player_monster_3": null
}

var monster4: Monster
var monster5: Monster
var monster6: Monster

func _ready():
	SaveManager.load_data()
	Events.request_challenge_npc.connect(_start_challenge)
	Events.request_end_battle.connect(handle_end_battle)

	var species_shadecry = preload("res://content/species/Shadecry.tres")
	var species_clouddog = preload("res://content/species/Clouddog.tres")

	print_machine()

	if player_monsters["player_monster_1"] == null:
		print("they are null")
		monster1 = MonsterController.create_monster(species_shadecry)
		monster2 = MonsterController.create_monster(species_clouddog, "Evil Reggie")
		monster3 = MonsterController.create_monster(species_clouddog, "Evil Steven")
	else:
		print("they are not null")
		monster1 = player_monsters["player_monster_1"]
		monster2 = player_monsters["player_monster_1"]
		monster3 = player_monsters["player_monster_1"]

	monster4 = MonsterController.create_monster(species_shadecry)
	monster5 = MonsterController.create_monster(species_clouddog, "Evil Reggie")
	monster6 = MonsterController.create_monster(species_clouddog, "Evil Steven")

func print_machine():
	print(player_location)
	print(player_monsters)
	print(unlocked_abilities)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("option_menu"):
		print("escape was used")
		Events.request_open_option_menu.emit()
		SaveManager.save_game()
		print("request_open_option_menu")
		Events.request_quit.emit()

func _start_challenge():
	print("challenge started")
	get_tree().change_scene_to_file.call_deferred("res://Scenes/UI/BattleScene.tscn")
	return

func handle_end_battle():
	battle_return = true
	SaveManager.save_game()
	get_tree().change_scene_to_file.call_deferred("res://Scenes/MapAssests/Room/PrototypeLevel.tscn")

func get_monster_save_data() -> Dictionary:
	var data = {}
	
	for key in player_monsters:
		var monster = player_monsters[key]
		if monster != null:
			data[key] = monster.to_save_data()
		else:
			data[key] = null
	return data

func load_monster_save_data(data: Dictionary):
	for key in data:
		if data[key] != null:
			player_monsters[key] = Monster.from_save_data(data[key])
		else:
			player_monsters[key] = null
