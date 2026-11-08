class_name ConditionResource extends Resource

@export var name: String
@export var element: MonsterElement.Element
@export var stat_modifiers: Array[StatModifier]
@export var on_begin_turn_effects: Array[TargetedEffect]
@export var duration: int = 2
@export var untargetable: bool
@export var restrained: bool
@export var evasion: bool
@export var short_name: String
