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
	print(player_monsters)
	
	print("typeof(player_monsters[player_monster_1])")
	print(typeof(player_monsters["player_monster_1"]))
	print(player_monsters["player_monster_1"] is Monster)
	print("player_monsters[player_monster_1]")
	print(player_monsters["player_monster_1"])
	
	if player_monsters["player_monster_1"] == null:
		set_player_monster()
	
	Events.request_challenge_npc.connect(_start_challenge)
	Events.request_end_battle.connect(handle_end_battle)

#	var species_intaxilote = preload("res://content/species/Intaxilote.tres")
	var species_umimmak = preload("res://content/species/Umimmak.tres")
#	var species_stjerne = preload("res://content/species/Stjerne.tres")
	var species_uppik = preload("res://content/species/Uppik.tres")
#	var species_ritari = preload("res://content/species/Ritari.tres")
	var species_natseq = preload("res://content/Species/Natseq.tres")

	print_machine()

	monster1 = player_monsters["player_monster_1"]
	monster2 = player_monsters["player_monster_2"]
	monster3 = player_monsters["player_monster_3"]

#	monster1 = MonsterController.create_monster(species_ritari, "Our Lord and Savior")
#	monster2 = MonsterController.create_monster(species_stjerne, "Sinless Steve")
#	monster3 = MonsterController.create_monster(species_intaxilote, "Evil Steven")

	monster4 = MonsterController.create_monster(species_umimmak, "non-evil Steven")
	monster5 = MonsterController.create_monster(species_natseq, "Fat bastard")
	monster6 = MonsterController.create_monster(species_uppik, "Sinful Steve")

func set_player_monster():
	var species_shadecry = preload("res://content/species/Shadecry.tres")
	var species_clouddog = preload("res://content/species/Clouddog.tres")
	player_monsters["player_monster_1"] = MonsterController.create_monster(species_shadecry)
	player_monsters["player_monster_2"] = MonsterController.create_monster(species_clouddog, "Evil Reggie")
	player_monsters["player_monster_3"] = MonsterController.create_monster(species_clouddog, "Evil Steven")

func heal_player_monster():
	print("full party heal")
	player_monsters["player_monster_1"].current_hp = player_monsters["player_monster_1"].max_hp
	player_monsters["player_monster_2"].current_hp = player_monsters["player_monster_2"].max_hp
	player_monsters["player_monster_3"].current_hp = player_monsters["player_monster_3"].max_hp

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
	if Input.is_action_just_pressed("heal"):
		heal_player_monster()

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
	print("loaded monster from save data")
	for key in data:
		if data[key] != null:
			player_monsters[key] = Monster.from_save_data(data[key])
			print(Monster.from_save_data(data[key]))
		else:
			player_monsters[key] = null
