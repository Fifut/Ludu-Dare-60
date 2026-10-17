extends AnimatableBody3D


@onready var left_flipper_on_audio: AudioStreamPlayer3D = $LeftFlipperOnAudio
@onready var left_flipper_off_audio: AudioStreamPlayer3D = $LeftFlipperOffAudio

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("left_flipper"):
		left_flipper_on_audio.play()
		
	elif Input.is_action_just_released("left_flipper"):
		left_flipper_off_audio.play()
