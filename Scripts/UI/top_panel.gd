class_name TopPanel extends Control

@export var round_label: Label
@export var terrain_label: Label

func _ready() -> void:
	# TODO: listen for events to connect and update the monster

	Events.round_changed.connect(update_round_label)
	Events.on_terrain_updated.connect(update_terrain_label)
	update_round_label(1)
	return

func update_round_label(r: int):
	round_label.text = "round:" + str(r)

func update_terrain_label(name: String):
	terrain_label.text = "Terrain " + name
