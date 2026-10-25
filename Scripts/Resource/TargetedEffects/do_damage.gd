class_name DoDamage extends TargetedEffect

@export var base_damage: int
@export var melee: bool
@export var ignore_stats: bool
@export var damage_log_string: String = "{doer_name} hits {target_name} for {amt} damage"
@export var critical_hit_damage_coefficient = 2

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
#	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	var type = source.get_type() if source.has_method("get_type") else MonsterType.Type.NORMAL

	var type_advantage_coefficient = MonsterType.get_type_advantage_coefficient(type, target.type)
	var stat_diff_coefficient = doer.range_damage - target.defense
	if melee:
		stat_diff_coefficient = doer.melee_damage - target.defense
	if ignore_stats:
		stat_diff_coefficient = 0
	
	var crit_coefficient = critical_hit_damage_coefficient if crit else 1

	if crit:
		print("get critted sucker")
	var amt = clamp((base_damage + stat_diff_coefficient) * type_advantage_coefficient * crit_coefficient, 0, 1000) 
	MonsterController.adjust_monster_hitpoints(target, -amt)
	
#	var effectiveness = MonsterType.get_type_effectiveness(type, target.type)
#	if effectiveness == MonsterType.Effectiveness.STRONG:
#		Events.request_log.emit("It is extra effective!")
#	elif effectiveness == MonsterType.Effectiveness.WEAK:
#		Events.request_log.emit("It is not very effective.")
	
#	Events.request_log.emit(damage_log_string\
#	.format({"doer_name": doer.name, "target_name": target.name, "amt": amt}))
