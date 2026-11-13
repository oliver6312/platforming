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
	get: return Calculations.calculate_monster_stat(species.base_max_hp, level, sum_condition_stats_for_code(Stat.Code.MAX_HP))
var current_hp: int

var defense: int:
	get: return Calculations.calculate_monster_stat(species.base_defense, level, sum_condition_stats_for_code(Stat.Code.DEF))
var speed: int:
	get: return Calculations.calculate_monster_stat(species.base_speed, level, sum_condition_stats_for_code(Stat.Code.SPD))
var melee_damage: int:
	get: return Calculations.calculate_monster_stat(species.base_melee_damage, level, sum_condition_stats_for_code(Stat.Code.MEL_ATK))
var range_damage: int:
	get: return Calculations.calculate_monster_stat(species.base_range_damage, level, sum_condition_stats_for_code(Stat.Code.RAN_ATK))

var priority

var moves: Array[Move]
var chosen_move

var element_one: MonsterElement.Element:
	get: return species.element_one
var element_two: MonsterElement.Element:
	get: return species.element_two

#	get: return Calculations.calculate_monster_stat(species.base_max_hp, hp_growth, level, sum_condition_stats_for_code(Stat.Code.MAX_HP), Stat.Code.MAX_HP)

func sum_condition_stats_for_code(code: Stat.Code):
	var sum = 0
	for condition in conditions:
		for stat_modifier in condition.resource.stat_modifiers:
			if stat_modifier.stat == code:
				sum += stat_modifier.modifier
	return sum

func get_condition_string():
	var condition_string = ""
	
	for condition in conditions:
		condition_string += "{name} - ({remaining})\n".format({"name": condition.name, "remaining": condition.duration_remaining})

	if conditions.size() == 0:
		return ""
	else:
		for condition in conditions:
			return condition_string

func dump_state():
	var condition_string = ""
	print("elements:")
	print(element_one)
	print(MonsterElement.Element)
	
	var element_one_dump: String = ""
	var element_two_dump: String = ""
	match element_one:
		MonsterElement.Element.NONE:
			element_one_dump = ""
		MonsterElement.Element.AIR:
			element_one_dump = "Air"
		MonsterElement.Element.EARTH:
			element_one_dump = "Earth"
		MonsterElement.Element.METAL:
			element_one_dump = "Metal"
		MonsterElement.Element.PLANT:
			element_one_dump = "Plant"
		MonsterElement.Element.SHADOW:
			element_one_dump = "Shadow"
		MonsterElement.Element.SNOW:
			element_one_dump = "Snow"
		MonsterElement.Element.SPARK:
			element_one_dump = "Spark"
		MonsterElement.Element.WATER:
			element_one_dump = "Water"
	match element_two:
		MonsterElement.Element.NONE:
			element_two_dump = ""
		MonsterElement.Element.AIR:
			element_two_dump = "Air"
		MonsterElement.Element.EARTH:
			element_two_dump = "Earth"
		MonsterElement.Element.METAL:
			element_two_dump = "Metal"
		MonsterElement.Element.PLANT:
			element_two_dump = "Plant"
		MonsterElement.Element.SHADOW:
			element_two_dump = "Shadow"
		MonsterElement.Element.SNOW:
			element_two_dump = "Snow"
		MonsterElement.Element.SPARK:
			element_two_dump = "Spark"
		MonsterElement.Element.WATER:
			element_two_dump = "Water"

	for condition in conditions:
		condition_string += "{name} - ({remaining})\n".format({"name": condition.name, "remaining": condition.duration_remaining})

	return "Name: {name}\nPrimary Element: {primary_element}\nSecondary Element: {secondary_element}\nHealth: ({current_hp}/{max_hp})\nMelee damage: {melee_damage}\nRanged damage: {range_damage}\nDefense: {defense}\nSpeed: {speed}"\
	.format({
		"name": name,
		"current_hp": current_hp,
		"max_hp": max_hp,
		"melee_damage": melee_damage,
		"range_damage": range_damage,
		"defense": defense,
		"speed": speed,
		"primary_element": element_one_dump,
		"secondary_element": element_two_dump
	})
