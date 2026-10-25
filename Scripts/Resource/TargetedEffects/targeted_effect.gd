class_name TargetedEffect extends Resource

@export var target_self: bool
@export var area_of_effect: bool

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	return
