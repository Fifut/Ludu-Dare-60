extends Node3D


var _initial_transform: Transform3D


func _ready() -> void:
	_initial_transform = global_transform
	
	GameManager.on_relay_click.connect(
		func(target_transform):
			global_transform = target_transform
	)
	
	GameManager.on_player_view.connect(
		func():
			global_transform = _initial_transform
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
