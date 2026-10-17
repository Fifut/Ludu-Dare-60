class_name Ball extends RigidBody3D


@onready var ball_audio: AudioStreamPlayer3D = %BallAudio

func _on_body_entered(body: Node) -> void:
	if body is Pinball:
		ball_audio.play()


func _on_body_exited(body: Node) -> void:
	if body is Pinball:
		ball_audio.stop()
