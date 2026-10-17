extends Node3D


@onready var electronics: Node3D = %Electronics
@onready var break_down_timer: Timer = %BreakDownTimer

@onready var score_wheel_100: Node3D = $ScoreWeels/ScoreWheel100
@onready var score_wheel_010: Node3D = $ScoreWeels/ScoreWheel010
@onready var score_wheel_001: Node3D = $ScoreWeels/ScoreWheel001


func _ready() -> void:
	break_down_timer.wait_time = randf_range(10.0, 20.0)
	
	GameManager.on_add_point.connect(
		func():
			score_wheel_001.add_point()
	)


func _break_component():
	var index = randi_range(0, electronics.get_child_count() - 1)
	var electronic: Electronic = electronics.get_child(index)
	if not electronic.broken:
		electronic.broken = true
		GameManager.broken_coil += 1


func _on_break_down_timer_timeout() -> void:
	break_down_timer.wait_time = randf_range(10.0, 20.0)
	_break_component()
	

func _on_score_wheel_001_on_score_overflow() -> void:
	score_wheel_010.add_point()


func _on_score_wheel_010_on_score_overflow() -> void:
	score_wheel_100.add_point()
