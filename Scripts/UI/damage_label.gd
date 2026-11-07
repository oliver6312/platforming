extends Label

var pop_up_size = 2.0
var growth_duration = 0.2
var shrink_duration = 0.5
var disappearance_delay = 0.6

func _ready() -> void:
	var damage_label_tween = get_tree().create_tween()
	damage_label_tween.set_parallel(true)
#	damage_label_tween.tween_property(self, "scale", Vector2(pop_up_size, pop_up_size), growth_duration)
#	damage_label_tween.tween_property(self, "scale", Vector2.ZERO, shrink_duration).set_delay(disappearance_delay)
	damage_label_tween.tween_property(self, "position:y", global_position.y - 30, 0.4)
	await damage_label_tween.finished
	queue_free()
	
