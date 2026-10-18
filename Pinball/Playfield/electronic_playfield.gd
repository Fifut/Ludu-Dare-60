extends Node3D


@onready var electronics: Node3D = %Electronics
@onready var break_down_timer: Timer = %BreakDownTimer

var _range: float = 15.0

func _ready() -> void:
	GameManager.on_game_start.connect(
		func():
			break_down_timer.start()
			_range = 15.0
	)
	
	GameManager.on_game_stop.connect(
		func():
			break_down_timer.stop()
	)


func _break_component():
	var index = randi_range(0, electronics.get_child_count() - 1)
	electronics.get_child(index).broken = true


func _on_break_down_timer_timeout() -> void:
	_range -= 1.0
	break_down_timer.wait_time = randf_range(_range, _range + 5.0)
	_break_component()
