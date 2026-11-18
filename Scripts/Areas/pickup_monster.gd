extends Area2D

@export var monster: SpeciesResource
@onready var sprite_2d: Sprite2D = %Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player exits room")
		GameManager.set_player_monster()
