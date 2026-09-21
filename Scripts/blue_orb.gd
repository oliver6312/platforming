extends Area2D

@export var unlocks: String
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	match unlocks:
				"dash":
					sprite_2d.texture = load("res://Sprites/Orb/OrangeMatOrb.png")
				"double jump":
					sprite_2d.texture = load("res://Sprites/Orb/GreenMatOrb.png")
				"wall jump":
					sprite_2d.texture = load("res://Sprites/Orb/BlueMatOrb.png")
	pass
	

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
		self.queue_free()
