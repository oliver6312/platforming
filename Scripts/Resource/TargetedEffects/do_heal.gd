class_name DoHeal extends TargetedEffect

@export var base_heal: int
@export var melee: bool
@export var damage_log_string: String = "{doer_name} heals {target_name} for {amt} health"

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
#	var target = doer if target_self else MonsterController.get_monster_opponent(doer)
	if target_self:
		target = doer

	var amt = clamp(base_heal, 0, 1000) 
	print(target.name)
	if !area_of_effect:
		MonsterController.adjust_monster_hitpoints(target, amt)
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
		MonsterController.adjust_monster_hitpoints(target_0, amt)
		MonsterController.adjust_monster_hitpoints(target_1, amt)
		MonsterController.adjust_monster_hitpoints(target_2, amt)
