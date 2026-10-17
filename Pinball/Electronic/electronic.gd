class_name Electronic extends StaticBody3D


@export var broken: bool:
	set(status):
		broken = status
		_click_to_fix = randi_range(2, 5)
		_set_color(Color.RED)
		

@onready var broken_gpu_particles: GPUParticles3D = %BrokenGPUParticles

@onready var relay_mesh: MeshInstance3D = %RelayMesh
@onready var coil_mesh: MeshInstance3D = %CoilMesh

@onready var click_timer: Timer = %ClickTimer

@onready var hammer_marker: Marker3D = %HammerMarker

@onready var click_audio: AudioStreamPlayer3D = %ClickAudio
@onready var broken_audio: AudioStreamPlayer3D = %BrokenAudio
@onready var fix_audio: AudioStreamPlayer3D = %FixAudio


var _click_to_fix: int = 3
var _relay_mesh_position: Vector3


func _ready() -> void:
	_relay_mesh_position = relay_mesh.position
	
	#GameManager.on_game_start.connect(
		#func():
			#pass
	#)
	
	GameManager.on_game_stop.connect(
		func():
			_reset_color()
			broken = false
			broken_audio.stop()
	)
	
	
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
		if broken:
			GameManager.on_relay_click.emit(hammer_marker.global_transform)
		
			click_audio.pitch_scale = randf_range(0.9, 1.1)
			click_audio.play()
			click_timer.start()
		
			_click_to_fix -= 1
			if _click_to_fix <= 0:
				_fixed()
