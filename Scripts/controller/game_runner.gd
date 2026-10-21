extends Node

enum BATTLE_PICK_MODE {MOVE, RANK, TARGET}

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	# Connect signal listeners
	Events.on_ui_ready.connect(setup_model)
	Events.request_quit.connect(handle_quit)
	Events.request_log.connect(handle_log)
	Events.request_move_by_index.connect(handle_request_move_by_index)

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
	battle_state.all_battle_monsters.sort_custom(func(a, b): return a.priority > b.priority)

	print(battle_state.round_size)
	start_turn()

func end_turn():
	start_turn()

func start_turn():
	battle_state.round_size = battle_state.all_battle_monsters.size()
	battle_state.turn_index += 1
	if battle_state.turn_index == battle_state.round_size:
		battle_state.round += 1
		battle_state.turn_index = 0
		Events.round_changed.emit(battle_state.round)
		print("turn index = round size")

	battle_state.active_monster = battle_state.all_battle_monsters[battle_state.turn_index]
	print(battle_state.active_monster.name)
	print(battle_state.active_monster.moves)
	Events.start_active_monster_turn.emit(battle_state.active_monster)
	

	pass

func resolve_turn():
	#maybe a mistake
	pass

func handle_request_move_by_index(index: int):
	print(index)
	battle_state.player_monster.chosen_move =\
	 MonsterController.get_monster_move_at_index(battle_state.active_monster, index)
	#note that game_state.player.current_monster was switched to battle_state.active_monster

func handle_log():
#	battle_state.all_opponent_monsters.append_array(battle_state.all_player_monsters)
	print(battle_state.all_battle_monsters)
#	print(battle_state.all_player_monsters)

func handle_quit():
	get_tree().quit()
