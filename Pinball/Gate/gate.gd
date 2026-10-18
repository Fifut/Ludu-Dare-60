extends StaticBody3D


@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D


func _ready() -> void:
	collision_shape_3d.disabled = true


func reset():
	collision_shape_3d.disabled = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Ball:
		collision_shape_3d.disabled = false
		
