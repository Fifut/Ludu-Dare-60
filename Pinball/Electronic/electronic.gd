class_name Electronic extends StaticBody3D


@export var broken: bool:
	set(status):
		broken = status
		_click_to_fix = randi_range(1, 3)
		_set_color(Color.RED)
		

@onready var broken_gpu_particles: GPUParticles3D = %BrokenGPUParticles

@onready var relay_mesh: MeshInstance3D = %RelayMesh
@onready var coil_mesh: MeshInstance3D = %CoilMesh

@onready var click_timer: Timer = %ClickTimer

@onready var hammer_marker: Marker3D = %HammerMarker

@onready var click_audio: AudioStreamPlayer3D = %ClickAudio
@onready var broken_audio: AudioStreamPlayer3D = %BrokenAudio
@onready var fix_audio: AudioStreamPlayer3D = %FixAudio


var _click_to_fix: int = 2
var _relay_mesh_position: Vector3


func _ready() -> void:
	_relay_mesh_position = relay_mesh.position
	
	
func _physics_process(_delta: float) -> void:
	if broken:
		broken_gpu_particles.emitting = true
		broken_audio.play()
	else:
		broken_gpu_particles.emitting = false
		broken_audio.stop()
	
	if not click_timer.is_stopped():
		relay_mesh.position.x = _relay_mesh_position.x + randf_range(0.0, 0.01)
		relay_mesh.position.y = _relay_mesh_position.y + randf_range(0.0, 0.01)
	else:
		relay_mesh.position = _relay_mesh_position


func _set_color(color: Color):
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color
	relay_mesh.material_override = material
	coil_mesh.material_override = material
	
	
func _reset_color():
		relay_mesh.material_override = null
		coil_mesh.material_override = null


func _fixed():
	broken = false
	fix_audio.play()
	_set_color(Color.GREEN)
	

func _on_fix_audio_finished() -> void:
	_reset_color()


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		GameManager.on_relay_click.emit(hammer_marker.global_transform)
		
		click_audio.pitch_scale = randf_range(0.9, 1.1)
		click_audio.play()
	
		click_timer.start()
		
		if broken:
			_click_to_fix -= 1
			
			if _click_to_fix <= 0:
				_fixed()
				
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#var camera: Camera3D = get_viewport().get_camera_3d()
		#var origin: Vector3 = camera.project_ray_origin(event.position)
		#var end: Vector3 = origin + camera.project_ray_normal(event.position) * 1000.0
		#var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		#var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(query)
		#if result and result.collider == self:
			#print("Clic sur le mesh")
