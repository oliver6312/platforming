class_name Calculations

#in the future the rng from gamerunner might need to be used here
static func calculate_monster_turn_order(monster1: Monster, monster2: Monster, monster3: Monster, monster4: Monster, monster5: Monster, monster6: Monster):
	monster1.priority = monster1.speed + GameRunner.rng.randf_range(0.0, 10.0)
	monster2.priority = monster2.speed + GameRunner.rng.randf_range(0.0, 10.0)
	monster3.priority = monster3.speed + GameRunner.rng.randf_range(0.0, 10.0)
	monster4.priority = monster4.speed + GameRunner.rng.randf_range(0.0, 10.0)
	monster5.priority = monster5.speed + GameRunner.rng.randf_range(0.0, 10.0)
	monster6.priority = monster6.speed + GameRunner.rng.randf_range(0.0, 10.0)
	

static func calculate_monster_stat(base: int, level: int, condition_bonus: int, stat_code: Stat.Code):
	return clamp(base + ((base / 100) * level) + condition_bonus, 1, 1000)
