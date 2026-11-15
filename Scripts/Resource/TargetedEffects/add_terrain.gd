class_name AddTerrain extends TargetedEffect

@export var terrain_resource: TerrainResource

func _do(doer: Monster, target: Monster, source: Object, battle_state: BattleState, crit: bool):
	var terrain = Terrain.new()
	terrain.resource = terrain_resource
	terrain.element = terrain_resource.element
	battle_state.active_terrain = terrain
	Events.on_terrain_updated.emit()
