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
