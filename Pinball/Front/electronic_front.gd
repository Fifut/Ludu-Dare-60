extends Node3D


@onready var electronics: Node3D = %Electronics
@onready var break_down_timer: Timer = %BreakDownTimer

@onready var score_wheel_100: Node3D = $ScoreWeels/ScoreWheel100
@onready var score_wheel_010: Node3D = $ScoreWeels/ScoreWheel010
@onready var score_wheel_001: Node3D = $ScoreWeels/ScoreWheel001


var _range: float = 15.0


func _ready() -> void:
	break_down_timer.wait_time = randf_range(10.0, 20.0)
	
	GameManager.on_add_point.connect(
		func():
			score_wheel_001.add_point()
	)
	
	GameManager.on_malfunction_puls.connect(
		func():
			score_wheel_001.add_point(-1)
	)
	
	GameManager.on_lose_ball.connect(
		func():
			score_wheel_010.add_point(-1)
	)
	
	GameManager.on_game_start.connect(
		func():
			break_down_timer.start()
			_range = 15.0
	)
	
	GameManager.on_game_stop.connect(
		func():
			break_down_timer.stop()
	)


#func _process(_delta: float) -> void:
	#bad_timer.wait_time = 10 - GameManager.broken_coil


func get_score() -> int:
	var score: int = 0
	score += score_wheel_001.get_point()
	score += score_wheel_010.get_point() * 10
	score += score_wheel_100.get_point() * 100
	return score


func _break_component():
	var index = randi_range(0, electronics.get_child_count() - 1)
	var electronic: Electronic = electronics.get_child(index)
	if not electronic.broken:
		electronic.broken = true
		

func _on_break_down_timer_timeout() -> void:
	_range -= 1.0
	break_down_timer.wait_time = randf_range(_range, _range + 5.0)
	_break_component()
	

func _on_score_wheel_001_on_score_overflow() -> void:
	score_wheel_010.add_point()


func _on_score_wheel_010_on_score_overflow() -> void:
	score_wheel_100.add_point()


func _on_score_wheel_100_on_score_underflow() -> void:
	pass


func _on_score_wheel_010_on_score_underflow() -> void:
	score_wheel_100.add_point(-1)


func _on_score_wheel_001_on_score_underflow() -> void:
	score_wheel_010.add_point(-1)
