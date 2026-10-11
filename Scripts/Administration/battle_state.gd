class_name BattleState

var player: Trainer
var opponent: Trainer
var is_player_turn: bool

var current_selected_monster: Monster

var all_opponent_monsters: Array:
	get: return opponent.monsters

var all_player_monsters: Array:
	get: return player.monsters

var all_combined_monsters: Array

var player_monster: Monster:
	get: return player.current_monster
var opponent_monster: Monster:
	get: return opponent.current_monster
