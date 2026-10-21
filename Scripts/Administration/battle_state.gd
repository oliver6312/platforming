class_name BattleState

#player stuff
var player: Trainer
var opponent: Trainer
var is_player_turn: bool

#gameplay flow (turn/order/round)
var round: int = 1
var round_size: int = 0
var turn_index: int = -1

#monster stuff
var all_opponent_monsters: Array:
	get: return opponent.monsters

var all_player_monsters: Array:
	get: return player.monsters

var all_battle_monsters: Array

var active_monster: Monster

var active_moves: Array[Move]
