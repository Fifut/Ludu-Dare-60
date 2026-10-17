class_name Pinball extends Node3D

signal on_game_over(score: int)

@onready var cameras: PinballCamera = %Cameras

@onready var flipper_1: AnimatableBody3D = $Pinball/Flipper_1
@onready var flipper_2: AnimatableBody3D = $Pinball/Flipper_2

@onready var glass: Node3D = $Pinball/Glass_1
@onready var playfield: Node3D = $Pinball/Playfield_1
#@onready var playfield_collision_shape: CollisionShape3D = %PlayfieldCollisionShape

@onready var electronic_front: Node3D = %"Electronic front"

@onready var spawn_ball_marker: Marker3D = %SpawnBallMarker
@onready var spawn_area: Area3D = %SpawnArea

@onready var ball_laoding_audio: AudioStreamPlayer3D = %BallLaodingAudio
@onready var ball_launch_audio: AudioStreamPlayer3D = %BallLaunchAudio

@onready var left_flipper_on_audio: AudioStreamPlayer3D = %LeftFlipperOnAudio
@onready var left_flipper_off_audio: AudioStreamPlayer3D = %LeftFlipperOffAudio
@onready var right_flipper_on_audio: AudioStreamPlayer3D = %RightFlipperOnAudio
@onready var right_flipper_off_audio: AudioStreamPlayer3D = %RightFlipperOffAudio

@onready var ball_in_play_value: Label3D = %BallInPlayValue

@onready var hurt_audio: AudioStreamPlayer3D = %HurtAudio

@onready var player_marker: Marker3D = %PlayerMarker

const BALL = preload("uid://cvxwk8nmkb0rn")

var _left_flip_target: float = -25.0
var _right_flip_target: float = -150.0
var _play: bool = false
var _ball_in_play: int = 4
var _ball: Ball



func _ready() -> void:
	flipper_1.rotation_degrees.y = _left_flip_target
	flipper_2.rotation_degrees.y = _right_flip_target
	
	GameManager.current_camera = player_marker
	
	GameManager.on_game_start.connect(
		func():
			_play = true
			ball_laoding_audio.play()
			playfield.show()
			glass.show()
			cameras.switch_to(PinballCamera.CAMERA.PLAYER)
	)
	
	GameManager.on_malfunction_puls.connect(
		func():
			hurt_audio.play()
	)
	

func _process(_delta: float) -> void:
	
	ball_in_play_value.text = str(_ball_in_play)
	
	if not _play:
		return

	# Camera manager
	if Input.is_action_just_pressed("playfield_view") and cameras.get_current_camera() == cameras.CAMERA.PLAYFIELD:
		cameras.switch_to(PinballCamera.CAMERA.PLAYER)
		playfield.show()
		glass.show()
		GameManager.on_player_view.emit()
		
	elif Input.is_action_just_pressed("front_view") and cameras.get_current_camera() == cameras.CAMERA.FRONT:
		cameras.switch_to(PinballCamera.CAMERA.PLAYER)
		playfield.show()
		glass.show()
		GameManager.on_player_view.emit()
		
	elif Input.is_action_just_pressed("playfield_view"):
		cameras.switch_to(PinballCamera.CAMERA.PLAYFIELD)
		playfield.hide()
		
	elif Input.is_action_just_pressed("front_view"):
		cameras.switch_to(PinballCamera.CAMERA.FRONT)
		glass.hide()
	 
	
	# Flipper
	if Input.is_action_just_pressed("left_flipper"):
		left_flipper_on_audio.play()
		_left_flip_target = 20.0
	elif Input.is_action_just_released("left_flipper"):
		left_flipper_off_audio.play()
		_left_flip_target = -25.0
		
	if Input.is_action_just_pressed("right_flipper"):
		right_flipper_on_audio.play()
		_right_flip_target = -200.0
	elif Input.is_action_just_released("right_flipper"):
		right_flipper_off_audio.play()
		_right_flip_target = -150.0
		

	
	flipper_1.rotation.y = lerp_angle(
		deg_to_rad(flipper_1.global_rotation_degrees.y),
		deg_to_rad(_left_flip_target),
		0.4
		)
		
	flipper_2.rotation.y = lerp_angle(
		deg_to_rad(flipper_2.global_rotation_degrees.y),
		deg_to_rad(_right_flip_target),
		0.4
		)

	# Launcher
	if Input.is_action_just_pressed("launch") and _ball != null:
		if spawn_area.overlaps_body(_ball):
			ball_launch_audio.play()
			_ball.apply_central_impulse(Vector3.FORWARD * randf_range(1.8, 2.0))


func start():
	_play = true
	_ball_in_play = 4
	ball_laoding_audio.play()
	playfield.show()
	glass.show()
	cameras.switch_to(PinballCamera.CAMERA.PLAYER)


func stop():
	_play = false
	cameras.switch_to(PinballCamera.CAMERA.IDLE)
	on_game_over.emit(electronic_front.get_score())


func _on_lose_area_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
		_ball_in_play -= 1
		if _ball_in_play > 0:
			start()
		else:
			stop()


func _on_ball_laoding_audio_finished() -> void:
	var ball: Ball = BALL.instantiate()
	spawn_ball_marker.add_child(ball, true)
	_ball = ball
