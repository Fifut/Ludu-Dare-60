class_name Pinball extends Node3D

@onready var cameras: PinballCamera = %Cameras

@onready var flipper_1: AnimatableBody3D = $Pinball/Flipper_1
@onready var flipper_2: AnimatableBody3D = $Pinball/Flipper_2

@onready var glass: Node3D = $Pinball/Glass_1
@onready var playfield: Node3D = $Pinball/Playfield_1
@onready var playfield_collision_shape: CollisionShape3D = %PlayfieldCollisionShape

@onready var spawn_ball_marker: Marker3D = %SpawnBallMarker
@onready var spawn_area: Area3D = %SpawnArea

@onready var ball_laoding_audio: AudioStreamPlayer3D = %BallLaodingAudio
@onready var ball_launch_audio: AudioStreamPlayer3D = %BallLaunchAudio


#@onready var electronic_playfield: Node3D = %"Electronic playfield"

const BALL = preload("uid://cvxwk8nmkb0rn")

var _left_flip_target: float = -25.0
var _right_flip_target: float = -150.0
#var _playfield_position: Vector3
#var _playfield_collision_position: Vector3
var _ball: Ball


func _ready() -> void:
	flipper_1.rotation_degrees.y = _left_flip_target
	flipper_2.rotation_degrees.y = _right_flip_target
	#_playfield_position = playfield._position
	#_playfield_collision_position = playfield._rotation_degrees
	

func _process(_delta: float) -> void:
	
	# Camera manager
	if Input.is_action_just_pressed("playfield_view") and cameras.get_current_camera() == cameras.CAMERA.PLAYFIELD:
		cameras.switch_to(PinballCamera.CAMERA.PLAYER)
		playfield.show()
		glass.show()
		GameManager.on_player_view.emit()
		#var tween = create_tween()
		#tween.set_ease(Tween.EASE_IN_OUT)
		#tween.set_trans(Tween.TRANS_CUBIC)
		#tween.set_parallel()
		#tween.tween_property(playfield, "position", _playfield_position, 0.2)
		#tween.tween_property(playfield, "rotation_degrees", _playfield_collision_position, 0.2)
		#tween.tween_property(playfield_collision_shape, "global_position", Vector3.ZERO, 0.2)
		#tween.tween_property(playfield_collision_shape, "global_rotation_degrees", Vector3.ZERO, 0.2)
		
	elif Input.is_action_just_pressed("front_view") and cameras.get_current_camera() == cameras.CAMERA.FRONT:
		cameras.switch_to(PinballCamera.CAMERA.PLAYER)
		#playfield_collision_shape.disabled = false
		playfield.show()
		glass.show()
		GameManager.on_player_view.emit()
		
	elif Input.is_action_just_pressed("playfield_view"):
		cameras.switch_to(PinballCamera.CAMERA.PLAYFIELD)
		#var tween = create_tween()
		#tween.set_ease(Tween.EASE_IN_OUT)
		#tween.set_trans(Tween.TRANS_CUBIC)
		#tween.set_parallel()
		#tween.tween_property(playfield, "global_position", Vector3(0.375, 1.35, -0.57), 0.2)
		#tween.tween_property(playfield, "global_rotation_degrees", Vector3(0.0, 0.0, -90.0), 0.2)
		#tween.tween_property(playfield_collision_shape, "global_position", Vector3.ZERO, 0.2)
		#tween.tween_property(playfield_collision_shape, "global_rotation_degrees", Vector3.ZERO, 0.2)
		#playfield_collision_shape.disabled = true
		playfield.hide()
		
	elif Input.is_action_just_pressed("front_view"):
		cameras.switch_to(PinballCamera.CAMERA.FRONT)
		glass.hide()
	 
	
	# Flipper
	if Input.is_action_just_pressed("left_flipper"):
		_left_flip_target = 20.0
	elif Input.is_action_just_released("left_flipper"):
		_left_flip_target = -25.0
		
	if Input.is_action_just_pressed("right_flipper"):
		_right_flip_target = -200.0
	elif Input.is_action_just_released("right_flipper"):
		_right_flip_target = -150.0

	
	flipper_1.rotation.y = lerp_angle(
		deg_to_rad(flipper_1.global_rotation_degrees.y),
		deg_to_rad(_left_flip_target),
		remap(GameManager.broken_coil, 0, 10, 0.2, 0.001)
		)
		
	flipper_2.rotation.y = lerp_angle(
		deg_to_rad(flipper_2.global_rotation_degrees.y),
		deg_to_rad(_right_flip_target),
		remap(GameManager.broken_coil, 0, 10, 0.2, 0.001)
		)

	# Launcher
	if Input.is_action_just_pressed("launch") and _ball != null:
		if spawn_area.overlaps_body(_ball):
			ball_launch_audio.play()
			_ball.apply_central_impulse(Vector3.FORWARD * randf_range(1.8, 2.0))


func start():
	ball_laoding_audio.play()
	playfield.show()
	glass.show()
	cameras.switch_to(PinballCamera.CAMERA.PLAYER)
	

func _on_lose_area_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
		start()


func _on_ball_laoding_audio_finished() -> void:
	var ball: Ball = BALL.instantiate()
	spawn_ball_marker.add_child(ball, true)
	_ball = ball
