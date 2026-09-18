extends Area2D

#@onready var player = %PlayerCharacter
@export var room = "HomeRoom"
@export var x_coodinate: float 
@export var y_coodinate: float 

func send_position() -> void:
	
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player exits room")
		match room:
			"HomeRoom":
				get_tree().change_scene_to_file.call_deferred("res://Scenes/Room/HomeRoom.tscn")
			"PrototypeRoom":
				get_tree().change_scene_to_file.call_deferred("res://Scenes/PrototypeLevel.tscn")
		GameManager.x_player_start_position = x_coodinate
		GameManager.y_player_start_position = y_coodinate
	pass
