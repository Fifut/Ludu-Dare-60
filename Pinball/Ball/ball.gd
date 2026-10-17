class_name Ball extends RigidBody3D


@onready var ball_audio: AudioStreamPlayer3D = %BallAudio


# Ball limit speed
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	state.linear_velocity = state.linear_velocity.limit_length(2.0)
	
	
func _on_body_entered(body: Node) -> void:
	if body is Pinball:
		ball_audio.play()


func _on_body_exited(body: Node) -> void:
	if body is Pinball:
		ball_audio.stop()
