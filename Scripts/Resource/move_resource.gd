class_name MoveResource extends Resource

@export var name: String
@export var melee: bool
@export var target_ally: bool
@export var target_self_only: bool
@export var area_of_effect: bool
@export var use_effects: Array[TargetedEffect]
@export var element: MonsterElement.Element
@export var use_message: String = "{user_name} uses {move_name}"

@export var rank: Array = [true, true, true]
@export var target: Array = [true, true, true]

@export var limited_usages: bool = false
@export var usage_max: int
