extends Node3D


@onready var electronics: Node3D = %Electronics
@onready var break_down_timer: Timer = %BreakDownTimer

func _ready() -> void:
	GameManager.on_game_start.connect(
		func():
			break_down_timer.start()
	)
	
	GameManager.on_game_stop.connect(
		func():
			break_down_timer.stop()
	)


func _break_component():
	var index = randi_range(0, electronics.get_child_count() - 1)
	electronics.get_child(index).broken = true


func _on_break_down_timer_timeout() -> void:
	break_down_timer.wait_time = randf_range(10.0, 20.0)
	_break_component()
