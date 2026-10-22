extends Resource
class_name SpeciesResource

enum Element {NONE, AIR, EARTH, ICE, METAL, PLANT, SHADOW, SPARK, WATER}

@export var name: String
@export var description: String
@export var starter_moves: Array[MoveResource]
#@export var minimal_height: int
#@export var maximal_height: int
#@export var minimal_weight: int
#@export var maximal_weight: int

@export var base_max_hp: int = 20
@export var base_defense: int = 20
@export var base_speed: int = 20
@export var base_melee_damage: int = 20
@export var base_range_damage: int = 20

@export var type: MonsterType.Type
@export var element_one: Element
@export var element_two: Element

@export var image: Texture2D
