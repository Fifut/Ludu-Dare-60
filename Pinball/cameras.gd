class_name PinballCamera extends Node3D

@onready var move_camera: Camera3D = %MoveCamera

@onready var idle_camera: Camera3D = %IdleCamera
@onready var player_camera: Camera3D = %PlayerCamera
@onready var playfield_camera: Camera3D = %PlayfieldCamera
@onready var front_camera: Camera3D = %FrontCamera

enum CAMERA {
	IDLE,
	PLAYER,
	PLAYFIELD,
	FRONT
}

var _current_camera: CAMERA = CAMERA.IDLE
var _camera_player_position: Vector3


func _ready() -> void:
	_camera_player_position = player_camera.position
	
	move_camera.transform = idle_camera.transform
	move_camera.fov = idle_camera.fov
	move_camera.make_current()
	
	GameManager.on_malfunction_puls.connect(
		func():
			var offset: float = GameManager.broken_coil / 100.0
			move_camera.position += Vector3(
				randf_range(-offset, offset),
				randf_range(-offset, offset),
				randf_range(-offset, offset)
			)
	)

func _process(_delta: float) -> void:
	
	match _current_camera:
		CAMERA.IDLE:
			move_camera.position = lerp(move_camera.position, idle_camera.position, 0.2)
			
		CAMERA.PLAYER:
			move_camera.position = lerp(move_camera.position, player_camera.position, 0.2)
			
		CAMERA.PLAYFIELD:
			move_camera.position = lerp(move_camera.position, playfield_camera.position, 0.2)

		CAMERA.FRONT:
			move_camera.position = lerp(move_camera.position, front_camera.position, 0.2)

	
func get_current_camera() -> CAMERA:
	return _current_camera


func switch_to(camera: CAMERA):

	var transform_target: Transform3D
	var fov_target: float
	
	match camera:
		CAMERA.IDLE:
			transform_target = idle_camera.global_transform
			fov_target = idle_camera.fov
			
		CAMERA.PLAYER:
			transform_target = player_camera.global_transform
			fov_target = player_camera.fov
			
		CAMERA.PLAYFIELD:
			transform_target = playfield_camera.global_transform
			fov_target = playfield_camera.fov
			
		CAMERA.FRONT:
			transform_target = front_camera.global_transform
			fov_target = front_camera.fov

	_current_camera = camera

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel()
	tween.tween_property(move_camera, "global_transform", transform_target, 0.3)
	tween.tween_property(move_camera, "fov", fov_target, 0.3)
