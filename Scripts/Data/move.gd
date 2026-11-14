class_name Move

var usages: int
var resource: MoveResource

var element: MonsterElement.Element:
	get: return resource.element

var name: String:
	get: return resource.name

var use_message: String:
	get: return resource.use_message

var target_area_of_effect: bool:
	get: return resource.area_of_effect
var target_self_only: bool:
	get: return resource.target_self_only
var target_ally: bool:
	get: return resource.target_ally

var rank: Array:
	get: return resource.rank
var target: Array:
	get: return resource.target

#used for duck-typing in TargetedEffect
func get_element() -> MonsterElement.Element:
	return element

func dump_state():
	var effect_string = ""

	for effect in resource.use_effects:
		if effect is AddCondition:
			effect_string += "Add %s condition\n" %[effect.condition_resource.name]
		if effect is CleanseCondition:
			effect_string += "Remove all conditions\n"
		if effect is DisplaceMonster:
			if effect.pull:
				effect_string += "Pull target forward\n"
			if effect.push:
				effect_string += "Push target backwards\n"
			if effect.shuffle:
				effect_string += "Randomly shuffle position\n"
		if effect is DoDamage:
			effect_string += "Deal %s damage\n" %[effect.base_damage]
		if effect is DoHeal:
			effect_string += "Heal %s hit points\n" %[effect.base_heal]

	var element_dump: String = ""
	match element:
		MonsterElement.Element.NONE:
			element_dump = ""
		MonsterElement.Element.AIR:
			element_dump = "Air"
		MonsterElement.Element.EARTH:
			element_dump = "Earth"
		MonsterElement.Element.METAL:
			element_dump = "Metal"
		MonsterElement.Element.PLANT:
			element_dump = "Plant"
		MonsterElement.Element.SHADOW:
			element_dump = "Shadow"
		MonsterElement.Element.SNOW:
			element_dump = "Snow"
		MonsterElement.Element.SPARK:
			element_dump = "Spark"
		MonsterElement.Element.WATER:
			element_dump = "Water"

	return "Name: {name}\nElement: {element}\nRank: {rank}\nTarget: {target}\n{effect}\nTarget Self: {target_self}\nTarget Ally: {target_ally}\nArea of Effect: {area_of_effect}"\
	.format({
		"name": name,
		"element": element_dump,
		"area_of_effect": target_area_of_effect,
		"target_self": target_self_only,
		"target_ally": target_ally,
		"rank": rank,
		"target": target,
		"effect": effect_string
	})
