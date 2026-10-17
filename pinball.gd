extends Node3D

@onready var player_camera: Camera3D = %PlayerCamera
@onready var playfield_camera: Camera3D = %PlayfieldCamera
@onready var front_camera: Camera3D = %FrontCamera

@onready var flipper_1: AnimatableBody3D = $Pinball/Flipper_1
@onready var flipper_2: AnimatableBody3D = $Pinball/Flipper_2

@onready var glass: Node3D = $Pinball/Glass_1
@onready var playfield: Node3D = $Pinball/Playfield_1

var _left_flip_target: float = -25.0
var _right_flip_target: float = -150.0


func _ready() -> void:
	flipper_1.rotation_degrees.y = _left_flip_target
	flipper_2.rotation_degrees.y = _right_flip_target


func _process(delta: float) -> void:
	
	# Camera manager
	if Input.is_action_just_pressed("playfield_view") and playfield_camera.current:
		player_camera.make_current()
		playfield.show()
		glass.show()
		
	elif Input.is_action_just_pressed("front_view") and front_camera.current:
		player_camera.make_current()
		playfield.show()
		glass.show()
		
	elif Input.is_action_just_pressed("playfield_view"):
		playfield_camera.make_current()
		playfield.hide()
		
	elif Input.is_action_just_pressed("front_view"):
		front_camera.make_current()
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
	
	#flipper_1.rotation_degrees.y = _left_flip_target
	#flipper_2.rotation_degrees.y = _right_flip_target
	
	flipper_1.rotation.y = lerp_angle(
		deg_to_rad(flipper_1.global_rotation_degrees.y),
		deg_to_rad(_left_flip_target),
		0.7)
		
	flipper_2.rotation.y = lerp_angle(
		deg_to_rad(flipper_2.global_rotation_degrees.y),
		deg_to_rad(_right_flip_target),
		0.7)


func _on_lose_area_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
