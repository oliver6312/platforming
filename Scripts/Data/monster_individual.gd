class_name Monster

var species: SpeciesResource
var image: Texture2D:
	get: return species.image
	
var nickname: String
var name: String:
	get: return nickname if nickname else species.name

var max_hp: int:
	get: return species.base_max_hp
var current_hp: int

var defense: int:
	get: return species.base_defense
var speed: int:
	get: return species.base_speed
var melee_damage: int:
	get: return species.base_melee_damage
var range_damage: int:
	get: return species.base_range_damage

var priority

var move_one: String
var move_two: String
var move_three: String

#var type: MonsterType.Type:
#	get: return species.type


#	get: return Calculations.calculate_monster_stat(species.base_max_hp, hp_growth, level, sum_condition_stats_for_code(Stat.Code.MAX_HP), Stat.Code.MAX_HP)

func dump_state():
	return "Name: {name}\nHealth: ({current_hp}/{max_hp})\nMelee damage: {melee_damage}\nRanged damage: {range_damage}\nDefense: {defense}\nSpeed: {speed}"\
	.format({
		"name": name,
		"current_hp": current_hp,
		"max_hp": max_hp,
		"melee_damage": melee_damage,
		"range_damage": range_damage,
		"defense": defense,
		"speed": speed,
	})
