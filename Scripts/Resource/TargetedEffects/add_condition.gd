class_name AddCondition extends TargetedEffect

@export var condition_resource: ConditionResource
@export var terrain_element_requirement: MonsterElement.Element
@export var target_condition_requirement: ConditionResource
@export var doer_condition_requirement: ConditionResource

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, _crit: bool):
	if !terrain_element_requirement == MonsterElement.Element.NONE:
		if !battle_state.active_terrain == null:
			if !battle_state.active_terrain.resource.element == terrain_element_requirement:
				return
		else:
			return

	var matching_condition: bool = false
	for condition in target.conditions:
		if condition.resource == target_condition_requirement:
			matching_condition = true
	if target_condition_requirement:
		if matching_condition == false:
			return
	for condition in doer.conditions:
		if condition.resource == doer_condition_requirement:
			matching_condition = true
	if doer_condition_requirement:
		if matching_condition == false:
			return

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
