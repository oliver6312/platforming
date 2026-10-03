extends Control

@export var player_monster_module1: MonsterRendererModule
@export var player_monster_module2: MonsterRendererModule
@export var player_monster_module3: MonsterRendererModule

@export var enemy_monster_module1: MonsterRendererModule
@export var enemy_monster_module2: MonsterRendererModule
@export var enemy_monster_module3: MonsterRendererModule

func _ready() -> void:
	player_monster_module1.connect_events()
	player_monster_module2.connect_events()
	player_monster_module3.connect_events()
	enemy_monster_module1.connect_events()
	enemy_monster_module2.connect_events()
	enemy_monster_module3.connect_events()
#	player_mon_state_dump.connect_events()
#	enemy_mon_state_dump.connect_events()

#	Events.on_battle_is_setup.connect(render)
	
	# Once listeners are connected, we need to emit an event to unblock gameplay
	Events.on_ui_ready.emit()

func render() -> void:
	player_monster_module1.belongs_to_player = true
	player_monster_module2.belongs_to_player = true
	player_monster_module3.belongs_to_player = true
	enemy_monster_module1.flip_h()
	enemy_monster_module2.connect_events()
	enemy_monster_module3.connect_events()
