extends Area2D

@onready var player_character: CharacterBody2D = $"../PlayerCharacter"

func _ready() -> void:
	var entrance = GameManager.entrance
	print("get entrance")
	var start_position: Vector2
	match entrance:
		1:
			var entrance_1: CollisionShape2D = %Entrance1
			start_position = entrance_1.position
			print(start_position)
		2:
			var entrance_2: CollisionShape2D = %Entrance2
			start_position = entrance_2.position
			print(start_position)
	player_character.position = start_position
#	return (start_position)
