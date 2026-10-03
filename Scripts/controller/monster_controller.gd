extends Node

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	battle_state = GameRunner.battle_state
	rng = GameRunner.rng
