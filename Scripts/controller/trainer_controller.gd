extends Node

var battle_state: BattleState
var rng: RandomNumberGenerator

func _ready():
	Events.on_new_game_state_created.connect(get_controller_components)

func get_controller_components():
	battle_state = GameRunner.battle_state
	rng = GameRunner.rng

func add_trainer_monster_to_battle(trainer: Trainer, monster_index: int):
	var monster = trainer.monsters[monster_index]
	trainer.current_monster_index = monster_index

	Events.on_monster_added_to_battle.emit(monster, trainer.is_player, monster_index)

func create_trainer(monsters: Array[Monster], is_player: bool) -> Trainer:
	var trainer = Trainer.new()
	trainer.is_player = is_player
	trainer.monsters = monsters 
	add_trainer_monster_to_battle(trainer, 0)
	return trainer
