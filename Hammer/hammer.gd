extends Node3D

@onready var mesh: MeshInstance3D = %Solide1

var _initial_transform: Transform3D
var _initial_position_z: float

var _stored: bool = true


func _ready() -> void:
	_initial_transform = global_transform
	_initial_position_z = mesh.position.z
	
	GameManager.on_relay_click.connect(
		func(target_transform):
			global_transform = target_transform
			mesh.position.z = _initial_position_z
			_stored = false
	)
	
	GameManager.on_player_view.connect(
		func():
			global_transform = _initial_transform
			_stored = true
	)


func _process(_delta: float) -> void:
	if _stored:
		mesh.position.z = _initial_position_z
	else:
		mesh.position.z = lerpf(mesh.position.z, _initial_position_z - 0.03, 0.1)
