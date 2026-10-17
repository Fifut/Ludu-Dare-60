class_name Electronic extends StaticBody3D


@export var broken: bool:
	set(status):
		broken = status
		_click_to_fix = randi_range(1, 3)
		

@onready var broken_gpu_particles: GPUParticles3D = %BrokenGPUParticles
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D
@onready var click_timer: Timer = %ClickTimer
@onready var click_audio: AudioStreamPlayer3D = %ClickAudio
@onready var broken_audio: AudioStreamPlayer3D = %BrokenAudio


var _click_to_fix: int = 2


func _physics_process(_delta: float) -> void:
	if broken:
		broken_gpu_particles.emitting = true
		broken_audio.play()
	else:
		broken_gpu_particles.emitting = false
		broken_audio.stop()
	
	if not click_timer.is_stopped():
		mesh_instance_3d.position.x = randf_range(0.0, 0.01)
		mesh_instance_3d.position.y = randf_range(0.0, 0.01)
	else:
		mesh_instance_3d.position = Vector3.ZERO




func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if not broken:
		return
	
	if event is InputEventMouseButton and event.pressed:
		click_audio.pitch_scale = randf_range(0.9, 1.1)
		click_audio.play()
		
		click_timer.start()
		_click_to_fix -= 1
		
		if _click_to_fix <= 0:
			broken = false


func _on_click_timer_timeout() -> void:
	pass # Replace with function body.
