extends Node

signal on_game_start()
signal on_game_stop()

signal on_add_point()

signal on_relay_click(relay_transform: Transform3D)

signal on_player_view()

var broken_coil: int = 0
