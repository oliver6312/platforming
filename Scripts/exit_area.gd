extends Area2D

#@onready var player = %PlayerCharacter
@export var room = "HomeRoom"
@export var exit: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player exits room")
		match room:
			"HomeRoom":
				get_tree().change_scene_to_file.call_deferred("res://Scenes/Room/HomeRoom.tscn")
				GameManager.entrance = exit
			"PrototypeRoom":
				get_tree().change_scene_to_file.call_deferred("res://Scenes/PrototypeLevel.tscn")
				GameManager.entrance = exit
	pass
