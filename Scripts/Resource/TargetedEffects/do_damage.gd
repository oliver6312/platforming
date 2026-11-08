class_name DoDamage extends TargetedEffect

@export var base_damage: int
@export var melee: bool
@export var ignore_stats: bool
@export var damage_log_string: String = "{doer_name} hits {target_name} for {amt} damage"
@export var critical_hit_damage_coefficient = 2
@export var condition_damage: bool = false

@export var bonus_damage_condition: ConditionResource
@export var bonus_damage_percentage: float = 1

var target_0: Monster 
var target_1: Monster 
var target_2: Monster

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	if target_self:
		target = doer

	if !area_of_effect:
		if MonsterController.check_for_evasion(target):
			print("deals no damage because the monster evaded")
			return
		MonsterController.adjust_monster_hitpoints(target, -get_amount(doer, target, source, crit))
		return

	make_monster_controller_adjust(doer, source, battle_state, crit)

func all_opponent_target(battle_state: BattleState):
	target_0 = battle_state.all_opponent_monsters[0]
	target_1 = battle_state.all_opponent_monsters[1]
	target_2 = battle_state.all_opponent_monsters[2]

func all_player_target(battle_state: BattleState):
	target_0 = battle_state.all_player_monsters[0]
	target_1 = battle_state.all_player_monsters[1]
	target_2 = battle_state.all_player_monsters[2]

func make_monster_controller_adjust(doer: Monster, source: Object, battle_state: BattleState, crit: bool):
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

	if MonsterController.check_for_evasion(target_0):
		print("deals no damage because the monster evaded")
		return
	MonsterController.adjust_monster_hitpoints(target_0, -get_amount(doer, target_0, source, crit))
	if MonsterController.check_for_evasion(target_1):
		print("deals no damage because the monster evaded")
		return
	MonsterController.adjust_monster_hitpoints(target_1, -get_amount(doer, target_1, source, crit))
	if MonsterController.check_for_evasion(target_2):
		print("deals no damage because the monster evaded")
		return
	MonsterController.adjust_monster_hitpoints(target_2, -get_amount(doer, target_2, source, crit))

func get_amount(doer: Monster, target: Monster, source: Object, crit: bool):
	var element = source.get_element() if source.has_method("get_element") else MonsterElement.Element.NONE
	var bonus_damage_total: float = 1

	var crit_coefficient = 2 if crit else 1
	if crit:
		print("get crit, idiot!")

	var type_advantage_coefficient = MonsterElement.get_element_advantage_coefficient(element, target.element)

	var stat_diff_coefficient = doer.range_damage - target.defense
	if melee:
		stat_diff_coefficient = doer.melee_damage - target.defense
	if ignore_stats:
		stat_diff_coefficient = 0

	for condition in target.conditions:
		if condition.resource == bonus_damage_condition:
			bonus_damage_total = bonus_damage_percentage
			print("bonus damage added")
			print(bonus_damage_total)

#	if target.conditions.filter(func(condition): 
#		return condition.resource == bonus_damage_condition): 
#			bonus_damage_total = bonus_damage_percentage
#			print("bonus damage added")
#			print(bonus_damage_total)

	var amt = clamp((base_damage + stat_diff_coefficient) * type_advantage_coefficient * crit_coefficient * bonus_damage_total, 0, 1000)
	Events.on_monster_damaged.emit(target, -amt, crit, type_advantage_coefficient)
	return amt
