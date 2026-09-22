extends Area2D

@export var character: String
@export var greetings: String
@export var battler: bool

var player_in_chat_zone = false 

func _process(_delta):
	if Input.is_action_just_pressed("attack") and player_in_chat_zone:
		print("player activates NPC")
		$Dialogue.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_chat_zone = true
		print("player enters NPC area")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_chat_zone = false
		print("player leaves NPC area")
