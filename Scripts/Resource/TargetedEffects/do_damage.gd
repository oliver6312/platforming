class_name DoDamage extends TargetedEffect

@export var base_damage: int
@export var melee: bool
@export var ignore_stats: bool
@export var damage_log_string: String = "{doer_name} hits {target_name} for {amt} damage"
@export var critical_hit_damage_coefficient = 2

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	if target_self:
		target = doer

	if !area_of_effect:
		MonsterController.adjust_monster_hitpoints(target, -get_amount(doer, target, source, crit))

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

		MonsterController.adjust_monster_hitpoints(target_0, -get_amount(doer, target_0, source, crit))

		MonsterController.adjust_monster_hitpoints(target_1, -get_amount(doer, target_1, source, crit))

		MonsterController.adjust_monster_hitpoints(target_2, -get_amount(doer, target_2, source, crit))

func all_opponent_target(battle_state: BattleState, amt):
	var target_0: Monster = battle_state.all_opponent_monsters[0]
	var target_1: Monster = battle_state.all_opponent_monsters[1]
	var target_2: Monster = battle_state.all_opponent_monsters[2]
	MonsterController.adjust_monster_hitpoints(target_0, amt)
	MonsterController.adjust_monster_hitpoints(target_1, amt)
	MonsterController.adjust_monster_hitpoints(target_2, amt)

func all_player_target(battle_state: BattleState, amt):
	var target_0: Monster = battle_state.all_player_monsters[0]
	var target_1: Monster = battle_state.all_player_monsters[1]
	var target_2: Monster = battle_state.all_player_monsters[2]
	MonsterController.adjust_monster_hitpoints(target_0, amt)
	MonsterController.adjust_monster_hitpoints(target_1, amt)
	MonsterController.adjust_monster_hitpoints(target_2, amt)

func get_amount(doer: Monster, target: Monster, source: Object, crit: bool):
	var element = source.get_element() if source.has_method("get_element") else MonsterElement.Element.NONE

	var crit_coefficient = critical_hit_damage_coefficient if crit else 1
	if crit:
		print("get crit, idiot!")

	var type_advantage_coefficient = MonsterElement.get_element_advantage_coefficient(element, target.element)

	var stat_diff_coefficient = doer.range_damage - target.defense
	if melee:
		stat_diff_coefficient = doer.melee_damage - target.defense
	if ignore_stats:
		stat_diff_coefficient = 0

	var amt = clamp((base_damage + stat_diff_coefficient) * type_advantage_coefficient * crit_coefficient, 0, 1000) 
	return amt
