extends Node

enum INTERACTION_MODE {NONE, FIGHT, ITEM, MON}
enum PHASE {AWAIT_INPUT, RESOLVE_ROUND, GAME_OVER}

var current_phase: PHASE

var game_manager: GameManager
var rng: RandomNumberGenerator

func _ready():
	# Connect signal listeners
	Events.on_ui_ready.connect(setup_model)
	


func setup_model():
	game_manager = GameManager.new()
	rng = RandomNumberGenerator.new()
#	Events.on_new_game_state_created.emit()
