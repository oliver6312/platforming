extends Area2D

@export var unlocks: String
@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	match unlocks:
				"dash":
					if GameManager.unlocked_abilities["dash"]:
						queue_free()
					sprite_2d.texture = load("res://Sprites/Orb/OrangeMatOrb.png")
				"double jump":
					if GameManager.unlocked_abilities["double_jump"]:
						queue_free()
					sprite_2d.texture = load("res://Sprites/Orb/GreenMatOrb.png")
				"wall jump":
					if GameManager.unlocked_abilities["wall_jump"]:
						queue_free()
					sprite_2d.texture = load("res://Sprites/Orb/BlueMatOrb.png")
	pass
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player exits room")
		match unlocks:
				"dash":
					GameManager.unlocked_abilities["dash"] = true
				"double jump":
					GameManager.unlocked_abilities["double_jump"] = true
				"wall jump":
					GameManager.unlocked_abilities["wall_jump"] = true
		self.queue_free()
