extends Node

enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}
enum PHASE {AWAIT_INPUT, RESOLVE_ROUND, GAME_OVER}

var current_phase: PHASE

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	# Connect signal listeners
	Events.on_ui_ready.connect(setup_model)
	Events.request_quit.connect(handle_quit)
	Events.request_log.connect(handle_log)
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

	Calculations.calculate_monster_turn_order(monster1, monster2, monster3, monster4, monster5, monster6)
	battle_state.all_battle_monsters = [monster1, monster2, monster3, monster4, monster5, monster6]

	current_phase = PHASE.AWAIT_INPUT

#func handle_run():
#	if current_phase != PHASE.AWAIT_INPUT:
#		return
#	Events.request_log.emit("You ran away. Your cowardice will not be forgotten.")
#	var timer = Timer.new()
#	add_child(timer)
#	timer.wait_time = 2.0
#	timer.start()
#	if timer.is_stopped():
#		get_tree().quit()

func handle_log():
#	battle_state.all_opponent_monsters.append_array(battle_state.all_player_monsters)
	print(battle_state.all_battle_monsters)
#	print(battle_state.all_player_monsters)

func handle_quit():
	get_tree().quit()
