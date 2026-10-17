extends AnimatableBody3D

@onready var right_flipper_on_audio: AudioStreamPlayer3D = $RightFlipperOnAudio
@onready var right_flipper_off_audio: AudioStreamPlayer3D = $RightFlipperOffAudio

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("right_flipper"):
		right_flipper_on_audio.play()
		
	elif Input.is_action_just_released("right_flipper"):
		right_flipper_off_audio.play()
