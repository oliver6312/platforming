class_name AddTerrain extends TargetedEffect

@export var terrain_resource: TerrainResource

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	var terrain = Terrain.new()
	terrain.resource = terrain_resource
	terrain.element = terrain_resource.element
	if !battle_state.active_terrain == null:
		var new_element_vs_old_element: int = MonsterElement.get_element_advantage_coefficient(terrain.element, battle_state.active_terrain.element)
		if new_element_vs_old_element == 2:
			battle_state.active_terrain = terrain
			Events.on_terrain_updated.emit(battle_state.active_terrain.resource.name)
			return
		return
	battle_state.active_terrain = terrain
	Events.on_terrain_updated.emit(battle_state.active_terrain.resource.name)
