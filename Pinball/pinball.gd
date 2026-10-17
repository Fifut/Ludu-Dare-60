class_name Pinball extends Node3D

@onready var cameras: PinballCamera = %Cameras

@onready var flipper_1: AnimatableBody3D = $Pinball/Flipper_1
@onready var flipper_2: AnimatableBody3D = $Pinball/Flipper_2

@onready var glass: Node3D = $Pinball/Glass_1
@onready var playfield: Node3D = $Pinball/Playfield_1
@onready var playfield_collision_shape: CollisionShape3D = %PlayfieldCollisionShape

@onready var electronic_playfield: Node3D = %"Electronic playfield"


var _left_flip_target: float = -25.0
var _right_flip_target: float = -150.0


func _ready() -> void:
	flipper_1.rotation_degrees.y = _left_flip_target
	flipper_2.rotation_degrees.y = _right_flip_target


func _process(_delta: float) -> void:
	
	# Camera manager
	if Input.is_action_just_pressed("playfield_view") and cameras.get_current_camera() == cameras.CAMERA.PLAYFIELD:
		cameras.switch_to(PinballCamera.CAMERA.PLAYER)
		playfield_collision_shape.disabled = false
		playfield.show()
		glass.show()
		
	elif Input.is_action_just_pressed("front_view") and cameras.get_current_camera() == cameras.CAMERA.FRONT:
		cameras.switch_to(PinballCamera.CAMERA.PLAYER)
		playfield_collision_shape.disabled = false
		playfield.show()
		glass.show()
		
	elif Input.is_action_just_pressed("playfield_view"):
		cameras.switch_to(PinballCamera.CAMERA.PLAYFIELD)
		playfield_collision_shape.disabled = true
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
		0.7)
		
	flipper_2.rotation.y = lerp_angle(
		deg_to_rad(flipper_2.global_rotation_degrees.y),
		deg_to_rad(_right_flip_target),
		0.7)


func start():
	pass
	

func _on_lose_area_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
