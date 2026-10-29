class_name DisplaceMonster extends TargetedEffect

@export var push: bool
@export var pull: bool
@export var shuffle: bool

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	print(battle_state.opponent.monsters)
	if shuffle:
#		if battle_state.player.monsters[doer]:
#			pass
		if battle_state.is_player_turn:
			shuffle_opponent_monsters(battle_state)
		else:
			shuffle_player_monsters(battle_state)
	push_opponent_monsters(battle_state, target)
	return

func pull_opponent_monsters(battle_state: BattleState, target: Monster):
	battle_state.opponent.monsters.erase(target)
	battle_state.opponent.monsters.push_front(target)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 0)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 1)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 2)

func pull_player_monsters(battle_state: BattleState, target: Monster):
	battle_state.player.monsters.erase(target)
	battle_state.player.monsters.push_front(target)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 0)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 1)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 2)

func push_opponent_monsters(battle_state: BattleState, target: Monster):
	battle_state.opponent.monsters.erase(target)
	battle_state.opponent.monsters.push_back(target)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 0)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 1)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 2)

func push_player_monsters(battle_state: BattleState, target: Monster):
	battle_state.player.monsters.erase(target)
	battle_state.player.monsters.push_back(target)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 0)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 1)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 2)

func shuffle_opponent_monsters(battle_state: BattleState):
	battle_state.opponent.monsters.shuffle()
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 0)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 1)
	TrainerController.add_trainer_monster_to_battle(battle_state.opponent, 2)

func shuffle_player_monsters(battle_state: BattleState):
	battle_state.player.monsters.shuffle()
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 0)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 1)
	TrainerController.add_trainer_monster_to_battle(battle_state.player, 2)
