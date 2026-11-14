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

#	for effect in resource.use_effects:
#		effect_string += "{name} - ({remaining})\n".format({"name": effect.name, "remaining": condition.duration_remaining})

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

	return "Name: {name}\nElement: {element}\nRank: {rank}\nTarget: {target}\nTarget Self: {target_self}\nTarget Ally: {target_ally}\nArea of Effect: {area_of_effect}"\
	.format({
		"name": name,
		"element": element_dump,
		"area_of_effect": target_area_of_effect,
		"target_self": target_self_only,
		"target_ally": target_ally,
		"rank": rank,
		"target": target
	})
