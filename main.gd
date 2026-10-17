extends Node3D


@onready var pinball: Pinball = %Pinball

@onready var start_button: Button = %StartButton


func _ready() -> void:
	randomize()


func _on_start_button_pressed() -> void:
	pinball.start()
