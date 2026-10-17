extends MeshInstance3D

@export var from: Node3D
@export var to: Node3D

@onready var lighting_timer: Timer = %LightingTimer


var _immediate_mesh: ImmediateMesh

func start():
	lighting_timer.start()


func _ready() -> void:
	_immediate_mesh = mesh as ImmediateMesh


func _process(_delta: float) -> void:
	if lighting_timer.is_stopped():
		_immediate_mesh.clear_surfaces()
		return
	
	if not to:
		to = GameManager.current_camera	
		
	var direction: Vector3 = (to.global_position - from.global_position)
	var dir_normalized: Vector3 = direction.normalized()

	_immediate_mesh.clear_surfaces()
	_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	_immediate_mesh.surface_add_vertex(to_local(from.global_position))
	
	for i: int in range(1, 4):
		var segment: float = float(i) / float(4)
		var point: Vector3 = from.global_position + direction * segment
		var vector_range: float = randf_range(0.0, 0.5)
		var random_vector: Vector3 = Vector3(
			randf_range(-vector_range, vector_range),
			randf_range(-vector_range, vector_range),
			randf_range(-vector_range, vector_range))
		var offset: Vector3 = random_vector.slide(dir_normalized) * 0.1
		_immediate_mesh.surface_add_vertex(to_local(point + offset))
		
	_immediate_mesh.surface_add_vertex(to_local(to.global_position))
	_immediate_mesh.surface_end()
