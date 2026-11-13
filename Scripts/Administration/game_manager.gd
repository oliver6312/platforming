extends Node

###player position
var entrance: int
var player_position: Vector2

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
	get_tree().change_scene_to_file.call_deferred("res://Scenes/MapAssests/Room/PrototypeLevel.tscn")
