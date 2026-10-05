extends Node

enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}
enum PHASE {AWAIT_INPUT, RESOLVE_ROUND, GAME_OVER}

var current_phase: PHASE

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	# Connect signal listeners
	Events.on_ui_ready.connect(setup_model)
#	Events.monster_selected_by_player.connect(change_selected_monster)

#func change_selected_monster(selected_monster: Monster):
#	print(selected_monster.nickname)
#	return selected_monster

func setup_model():
	rng = RandomNumberGenerator.new()
	battle_state = BattleState.new()
	Events.on_new_game_state_created.emit()

	var species_shadecry = preload("res://content/species/Shadecry.tres")
	var species_clouddog = preload("res://content/species/Clouddog.tres")

	var monster1 = MonsterController.create_monster(species_shadecry)
	var monster2 = MonsterController.create_monster(species_shadecry, "Reggie")
	var monster3 = MonsterController.create_monster(species_shadecry, "Steven")
	
	var monster4 = MonsterController.create_monster(species_clouddog)
	var monster5 = MonsterController.create_monster(species_clouddog, "Evil Reggie")
	var monster6 = MonsterController.create_monster(species_clouddog, "Evil Steven")

	battle_state.player = TrainerController.create_trainer([monster1, monster2, monster3], true)
	battle_state.opponent = TrainerController.create_trainer([monster4, monster5, monster6], false)

	current_phase = PHASE.AWAIT_INPUT
