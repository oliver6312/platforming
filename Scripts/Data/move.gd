class_name Move

var usages: int
var resource: MoveResource

#var type: MonsterType.Type:
#	get: return resource.type

var name: String:
	get: return resource.name

var use_message: String:
	get: return resource.use_message

var target_self_only: bool:
	get: return resource.target_self_only

var rank: Array:
	get: return resource.rank
var target: Array:
	get: return resource.target

#used for duck-typing in TargetedEffect
#func get_type() -> MonsterType.Type:
#	return type
