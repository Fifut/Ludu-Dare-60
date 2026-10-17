extends Area3D

@export var bumper_mesh: MeshInstance3D

@onready var hit_audio: AudioStreamPlayer3D = %HitAudio
@onready var omni_light_3d: OmniLight3D = %OmniLight3D


func _ready() -> void:
	omni_light_3d.hide()
	

func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		var direction: Vector3 = body.global_position - global_position
		direction.y = 0.0
		body.apply_central_impulse(direction.normalized() * 1.5)
		
		omni_light_3d.show()
		
		hit_audio.play()
		GameManager.on_add_point.emit()
		


func _on_hit_audio_finished() -> void:
	omni_light_3d.hide()
