extends Node

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	battle_state = GameRunner.battle_state
	rng = GameRunner.rng

func get_monster_move_at_index(monster: Monster, index: int) -> Move:
	return monster.moves[index]

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
