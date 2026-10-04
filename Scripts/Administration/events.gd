extends Node

# Events sent from dialogue
signal request_challenge_npc

# Events sent from battle renderer
signal on_ui_ready

# Events sent from game runner
signal on_new_game_state_created

# Events sent from trainer controller
signal on_monster_added_to_battle
signal on_monster_updated
