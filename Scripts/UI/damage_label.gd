extends Label

func _ready() -> void:
	var damage_label_tween = get_tree().create_tween()
	damage_label_tween.set_parallel(true)
	damage_label_tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.2)
	damage_label_tween.tween_property(self, "scale", Vector2.ZERO, 0.5).set_delay(0.6)
	damage_label_tween.tween_property(self, "position:y", global_position.y - 80, 2.0).set_delay(0.6)
	await damage_label_tween.finished
	queue_free()
	
