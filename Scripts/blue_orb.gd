extends Area2D

@export var unlocks: String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player exits room")
		match unlocks:
				"dash":
					GameManager.dash_unlock = true
				"double jump":
					GameManager.double_jump_unlock = true
				"wall jump":
					GameManager.wall_jump_unlock = true
