class_name AddCondition extends TargetedEffect

@export var condition_resource: ConditionResource
@export var chance_to_apply: float = 1.0

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	if target_self:
		target = doer

	if !area_of_effect:
		MonsterController.instantiate_condition_on_monster(target, condition_resource)
	if area_of_effect:
		var target_0: Monster
		var target_1: Monster
		var target_2: Monster
		if source.target_ally:
			print("target ally area of effect")
			if battle_state.is_player_turn:
				target_0 = battle_state.all_player_monsters[0]
				target_1 = battle_state.all_player_monsters[1]
				target_2 = battle_state.all_player_monsters[2]
			else:
				target_0 = battle_state.all_opponent_monsters[0]
				target_1 = battle_state.all_opponent_monsters[1]
				target_2 = battle_state.all_opponent_monsters[2]
		else:
			print("target enemy area of effect")
			if !battle_state.is_player_turn:
				target_0 = battle_state.all_player_monsters[0]
				target_1 = battle_state.all_player_monsters[1]
				target_2 = battle_state.all_player_monsters[2]
			else:
				target_0 = battle_state.all_opponent_monsters[0]
				target_1 = battle_state.all_opponent_monsters[1]
				target_2 = battle_state.all_opponent_monsters[2]
		MonsterController.instantiate_condition_on_monster(target_0, condition_resource)
		MonsterController.instantiate_condition_on_monster(target_1, condition_resource)
		MonsterController.instantiate_condition_on_monster(target_2, condition_resource)
	return
