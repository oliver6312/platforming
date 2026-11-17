extends Area2D

@export var unlocks: String
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	match unlocks:
				"dash":
					if GameManager.dash_unlock:
						queue_free()
					sprite_2d.texture = load("res://Sprites/Orb/OrangeMatOrb.png")
				"double jump":
					if GameManager.double_jump_unlock:
						queue_free()
					sprite_2d.texture = load("res://Sprites/Orb/GreenMatOrb.png")
				"wall jump":
					if GameManager.wall_jump_unlock:
						queue_free()
					sprite_2d.texture = load("res://Sprites/Orb/BlueMatOrb.png")
	pass
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player exits room")
		match unlocks:
				"dash":
					GameManager.unlocked_abilities[0] = true
				"double jump":
					GameManager.unlocked_abilities[1] = true
				"wall jump":
					GameManager.unlocked_abilities[2] = true
		self.queue_free()
