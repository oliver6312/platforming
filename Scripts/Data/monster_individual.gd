class_name Monster

var species: SpeciesResource
var level: int = 1
var image: Texture2D:
	get: return species.image

var nickname: String
var name: String:
	get: return nickname if nickname else species.name

var battle_position: int
var conditions: Array[Condition]

var max_hp: int:
	get: return Calculations.calculate_monster_stat(species.base_max_hp, level, sum_condition_stats_for_code(Stat.Code.MAX_HP), Stat.Code.MAX_HP)
var current_hp: int

var defense: int:
	get: return Calculations.calculate_monster_stat(species.base_defense, level, sum_condition_stats_for_code(Stat.Code.DEF), Stat.Code.DEF)
var speed: int:
	get: return Calculations.calculate_monster_stat(species.base_speed, level, sum_condition_stats_for_code(Stat.Code.SPD), Stat.Code.SPD)
var melee_damage: int:
	get: return Calculations.calculate_monster_stat(species.base_melee_damage, level, sum_condition_stats_for_code(Stat.Code.MEL_ATK), Stat.Code.MEL_ATK)
var range_damage: int:
	get: return Calculations.calculate_monster_stat(species.base_range_damage, level, sum_condition_stats_for_code(Stat.Code.RAN_ATK), Stat.Code.RAN_ATK)

var priority

var moves: Array[Move]
var chosen_move

var element: MonsterElement.Element:
	get: return species.element_one


#	get: return Calculations.calculate_monster_stat(species.base_max_hp, hp_growth, level, sum_condition_stats_for_code(Stat.Code.MAX_HP), Stat.Code.MAX_HP)

func sum_condition_stats_for_code(code: Stat.Code):
	var sum = 0
	for condition in conditions:
		for stat_modifier in condition.resource.stat_modifiers:
			if stat_modifier.stat == code:
				sum += stat_modifier.modifier
	return sum

func dump_state():
	var condition_string = ""
	
	for condition in conditions:
		condition_string += "{name} - ({remaining})\n".format({"name": condition.name, "remaining": condition.duration_remaining})


	return "Name: {name}\nHealth: ({current_hp}/{max_hp})\nMelee damage: {melee_damage}\nRanged damage: {range_damage}\nDefense: {defense}\nSpeed: {speed}\nConditions: {conditions}"\
	.format({
		"name": name,
		"current_hp": current_hp,
		"max_hp": max_hp,
		"melee_damage": melee_damage,
		"range_damage": range_damage,
		"defense": defense,
		"speed": speed,
		"conditions": condition_string
	})
