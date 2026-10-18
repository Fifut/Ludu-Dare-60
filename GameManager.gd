extends Node

@warning_ignore_start("unused_signal")

signal on_game_start()
signal on_game_stop()
signal on_lose_ball()

signal on_add_point()
signal on_malfunction_puls()

signal on_relay_click(relay_transform: Transform3D)

signal on_player_view()


var current_camera: Node3D
var broken_coil: int = 0
