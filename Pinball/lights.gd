extends Node3D


func _on_lights_timer_timeout() -> void:
	for light in get_children():
		if light is OmniLight3D:
			light.visible = not light.visible
