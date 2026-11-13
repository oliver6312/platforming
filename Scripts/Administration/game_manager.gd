extends Node

###player position
var entrance: int
var player_position: Vector2
var battle_return: bool

###player unlocks
var dash_unlock: bool = false
var double_jump_unlock: bool = false
var wall_jump_unlock: bool = false

#
func _ready():
	Events.request_challenge_npc.connect(_start_challenge)
	Events.request_end_battle.connect(handle_end_battle)

func _start_challenge():
	print("challenge started")
	get_tree().change_scene_to_file.call_deferred("res://Scenes/UI/BattleScene.tscn")
	return

func handle_end_battle():
	battle_return = true
	get_tree().change_scene_to_file.call_deferred("res://Scenes/MapAssests/Room/PrototypeLevel.tscn")
