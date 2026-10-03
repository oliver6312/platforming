class_name MonsterRendererModule extends Control

# This is a UI panel that handles all visuals for a monster in the battle, 
# including its sprite, HPbar and name

@export 
var monster_position: int

@export 
var belongs_to_player: bool

@export 
var frame: Control

@export
var data_panel: Control

@export
var name_label: Label

@export
var hp_label: Label

@export 
var hp_bar: ProgressBar

@export
var status_label: Label

@export
var sprite: Sprite2D

func _ready() -> void:
	# TODO: listen for events to connect and update the monster
	return
	
func connect_events() -> void:
	Events.on_ui_ready.connect(if_monster_enemy)
	return

func if_monster_enemy() -> void:
	print("Checking if monster is enemy")
	if belongs_to_player:
		return
	sprite.flip_h = true
