class_name DoDamage extends TargetedEffect

@export var base_damage: int
@export var melee: bool
@export var ignore_stats: bool
@export var damage_log_string: String = "{doer_name} hits {target_name} for {amt} damage"
@export var critical_hit_damage_coefficient = 2

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
#	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	if target_self:
		target = doer

	var element = source.get_element() if source.has_method("get_element") else MonsterElement.Element.NONE

	var type_advantage_coefficient = MonsterElement.get_element_advantage_coefficient(element, target.element)
	print("type_advantage_coefficient")
	print(type_advantage_coefficient)
	var stat_diff_coefficient = doer.range_damage - target.defense
	if melee:
		stat_diff_coefficient = doer.melee_damage - target.defense
	if ignore_stats:
		stat_diff_coefficient = 0
	
	var crit_coefficient = critical_hit_damage_coefficient if crit else 1

	var amt = clamp((base_damage + stat_diff_coefficient) * type_advantage_coefficient * crit_coefficient, 0, 1000) 
	print("amt")
	print(amt)
	if !area_of_effect:
		MonsterController.adjust_monster_hitpoints(target, -amt)
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
			if !battle_state.is_player_turn:
				target_0 = battle_state.all_player_monsters[0]
				target_1 = battle_state.all_player_monsters[1]
				target_2 = battle_state.all_player_monsters[2]
			else:
				target_0 = battle_state.all_opponent_monsters[0]
				target_1 = battle_state.all_opponent_monsters[1]
				target_2 = battle_state.all_opponent_monsters[2]
			print("target enemy area of effect")
		MonsterController.adjust_monster_hitpoints(target_0, -amt)
		MonsterController.adjust_monster_hitpoints(target_1, -amt)
		MonsterController.adjust_monster_hitpoints(target_2, -amt)
	
#	var effectiveness = MonsterType.get_type_effectiveness(type, target.type)
#	if effectiveness == MonsterType.Effectiveness.STRONG:
#		Events.request_log.emit("It is extra effective!")
#	elif effectiveness == MonsterType.Effectiveness.WEAK:
#		Events.request_log.emit("It is not very effective.")
	
#	Events.request_log.emit(damage_log_string\
#	.format({"doer_name": doer.name, "target_name": target.name, "amt": amt}))
