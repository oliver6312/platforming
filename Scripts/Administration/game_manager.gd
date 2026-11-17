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

var monster4: Monster
var monster5: Monster
var monster6: Monster

func _ready():
	SaveManager.load_data()
	Events.request_challenge_npc.connect(_start_challenge)
	Events.request_end_battle.connect(handle_end_battle)

	var species_shadecry = preload("res://content/species/Shadecry.tres")
	var species_clouddog = preload("res://content/species/Clouddog.tres")

	monster1 = MonsterController.create_monster(species_clouddog)
	monster2 = MonsterController.create_monster(species_shadecry, "Reggie")
	monster3 = MonsterController.create_monster(species_shadecry, "Steven")

	monster4 = MonsterController.create_monster(species_shadecry)
	monster5 = MonsterController.create_monster(species_clouddog, "Evil Reggie")
	monster6 = MonsterController.create_monster(species_clouddog, "Evil Steven")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("option_menu"):
		Events.request_open_option_menu.emit()
		SaveManager.save_game()
		Events.request_quit.emit()
		print("request_open_option_menu")

func _start_challenge():
	print("challenge started")
	get_tree().change_scene_to_file.call_deferred("res://Scenes/UI/BattleScene.tscn")
	return

func handle_end_battle():
	battle_return = true
	get_tree().change_scene_to_file.call_deferred("res://Scenes/MapAssests/Room/PrototypeLevel.tscn")
