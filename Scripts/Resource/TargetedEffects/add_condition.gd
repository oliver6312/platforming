class_name AddCondition extends TargetedEffect

@export var condition_resource: ConditionResource
@export var chance_to_apply: float = 1.0

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	if GameRunner.rng.randf() < chance_to_apply:
		#TODO create a move from the resource and add it to the target
		MonsterController.instantiate_condition_on_monster(target, condition_resource)
	return
