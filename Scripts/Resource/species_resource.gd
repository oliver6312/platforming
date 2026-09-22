extends Resource
class_name SpeciesResource

enum Element {NONE, AIR, EARTH, ICE, METAL, PLANT, SHADOW, SPARK, WATER}

@export var name: String
@export var description: String
@export var learnable_moves: Array
@export var minimal_height: int
@export var maximal_height: int
@export var minimal_weight: int
@export var maximal_weight: int

@export var base_max_hp: int
@export var base_defense: int
@export var base_speed: int
@export var base_melee_damage: int
@export var base_range_damage: int

@export var growth_max_hp: int
@export var growth_defense: int
@export var growth_speed: int
@export var growth_melee_damage: int
@export var growth_range_damage: int

@export var element_one: Element
@export var element_two: Element

@export var sprite: Texture2D
