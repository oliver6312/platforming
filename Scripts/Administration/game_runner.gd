extends Node

enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}
enum PHASE {AWAIT_INPUT, RESOLVE_ROUND, GAME_OVER}

var current_phase: PHASE

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	# Connect signal listeners
	Events.on_ui_ready.connect(setup_model)
	

func setup_model():
	rng = RandomNumberGenerator.new()
	battle_state = BattleState.new()
#	Events.on_new_game_state_created.emit()
