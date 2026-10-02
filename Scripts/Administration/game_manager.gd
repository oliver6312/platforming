extends Node
var entrance: int

###player unlocks
var dash_unlock: bool = false
var double_jump_unlock: bool = false
var wall_jump_unlock: bool = false

# 
func _ready():
	Events.request_challenge_npc.connect(_start_challenge)
	
func _start_challenge():
	print("challenge started")
	get_tree().change_scene_to_file.call_deferred("res://Scenes/UI/BattleScene.tscn")
	return
