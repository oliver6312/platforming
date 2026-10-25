extends Node

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	battle_state = GameRunner.battle_state
	rng = GameRunner.rng

func do_monster_turn(monster: Monster, target: Monster, index: int) -> Move:
#	print("this is the index:")
#	print(index)
#	return monster.moves[index]
	if monster.current_hp > 0:
		use_monster_move(monster, target, monster.moves[index])
	return

func use_monster_move(monster: Monster, target: Monster, move: Move):
#	if move.usages <= 0:
#		return
	
#	var use_string = move.use_message.format({"user_name": monster.name, "move_name": move.name})
#	Events.request_log.emit(use_string)
	
	var opponent = get_monster_opponent(monster)
#	if opponent.hp == 0:
#		monster.move_blocked = false
#		return
	
#	if monster.move_blocked:
#		Events.request_log.emit("But they can't move!")
#		monster.move_blocked = false
#		print("attack did not go through")
#		GameRunner.on_turn_ended()
#		return
#	move.usages -= 1
#	print("attack went through")

#	var hit = rng.randf() < move.base_accuracy
#	if !hit:
#		Events.request_log.emit("but it misses")
	var crit = rng.randf() < 0.05
#	if crit and hit:
#		Events.request_log.emit("Critical hit!")
	
	for effect in move.resource.use_effects:
		effect._do(monster, target, move, battle_state, crit)
#	GameRunner.on_turn_ended()

func adjust_monster_hitpoints(monster: Monster, amount: int):
	monster.current_hp = clamp(monster.current_hp + amount, 0, monster.max_hp)
	print("deals this much damage:")
	print(amount)
#	if monster.hp == 0:
#		faint_monster(monster)
		
#	Events.on_monster_updated.emit(monster)

func get_monster_opponent(monster: Monster) -> Monster:
	#must be fixed later to find the desired target
	return battle_state.all_battle_monsters[0]
	return null

func create_monster(species: SpeciesResource, nickname: String = "") -> Monster:
	var monster = Monster.new()
	monster.species = species
	monster.current_hp = monster.max_hp
	monster.nickname = nickname

	var moves: Array[Move] = []
	for move_resource in species.starter_moves:
		if move_resource == null:
			continue
		var move = Move.new()
		move.resource = move_resource
		moves.append(move)
	monster.moves = moves
	
#	monster.fallback_move = Move.new()
#	monster.fallback_move.resource = preload("res://content/moves/smack.tres")
#	monster.fallback_move.usages = 999
	return monster
