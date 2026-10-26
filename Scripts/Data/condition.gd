class_name  Condition

var resource: ConditionResource
var duration_remaining: int

var name: String:
	get: return resource.name

#used for duck-typing in TargetedEffect
func get_type() -> MonsterElement.Element:
	return MonsterElement.Element.NONE
