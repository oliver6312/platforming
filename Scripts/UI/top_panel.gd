class_name TopPanel extends Control

@export var round_label: Label

func _ready() -> void:
	# TODO: listen for events to connect and update the monster

	Events.round_changed.connect(update_round_label)
	update_round_label(1)
	return

func update_round_label(round: int):
	round_label.text = "round:" + str(round)
