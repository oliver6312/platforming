class_name DoHeal extends TargetedEffect

@export var base_heal: int
@export var melee: bool
@export var damage_log_string: String = "{doer_name} heals {target_name} for {amt} health"
@export var critical_hit_damage_coefficient = 2

@export var bonus_damage_condition: ConditionResource
@export var bonus_damage_percentage: float = 1

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
#	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	if target_self:
		target = doer

	var amt = clamp(base_heal * critical_hit_damage_coefficient, 0, 1000) 
	print(target.name)
	if !area_of_effect:
		MonsterController.adjust_monster_hitpoints(target, get_amount(doer, target, source, crit))
		return

	make_monster_controller_adjust(doer, source, battle_state, crit)

func make_monster_controller_adjust(doer: Monster, source: Object, battle_state: BattleState, crit: bool):
	var target_0: Monster = battle_state.all_opponent_monsters[0]
	var target_1: Monster = battle_state.all_opponent_monsters[1]
	var target_2: Monster = battle_state.all_opponent_monsters[2]
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

	if !target_0.current_hp == 0:
		MonsterController.adjust_monster_hitpoints(target_0, get_amount(doer, target_0, source, crit))
	if !target_1.current_hp == 0:
		MonsterController.adjust_monster_hitpoints(target_1, get_amount(doer, target_1, source, crit))
	if !target_2.current_hp == 0:
		MonsterController.adjust_monster_hitpoints(target_2, get_amount(doer, target_2, source, crit))

func all_opponent_target(battle_state: BattleState, amt):
	var target_0: Monster = battle_state.all_opponent_monsters[0]
	var target_1: Monster = battle_state.all_opponent_monsters[1]
	var target_2: Monster = battle_state.all_opponent_monsters[2]
	if !battle_state.all_opponent_monsters[0].current_hp == 0:
		MonsterController.adjust_monster_hitpoints(target_0, amt)
	if !battle_state.all_opponent_monsters[1].current_hp == 0:
		MonsterController.adjust_monster_hitpoints(target_1, amt)
	if !battle_state.all_opponent_monsters[2].current_hp == 0:
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
	var bonus_damage_total: float = 1

	var crit_coefficient = critical_hit_damage_coefficient if crit else 1
	if crit:
		print("get crit, idiot!")

	var type_advantage_coefficient = MonsterElement.get_element_advantage_coefficient(element, target.element_one)

	for condition in target.conditions:
		if condition.resource == bonus_damage_condition:
			bonus_damage_total = bonus_damage_percentage
			print("bonus healing added")
			print(bonus_damage_total)

#	if target.conditions.filter(func(condition): 
#		return condition.resource == bonus_damage_condition): 
#			bonus_damage_total = bonus_damage_percentage
#			print("bonus damage added")
#			print(bonus_damage_total)

	var amt = clamp((base_heal) * type_advantage_coefficient * crit_coefficient * bonus_damage_total, 0, 1000)
	Events.on_monster_damaged.emit(target, amt, crit, type_advantage_coefficient)
	return amt
