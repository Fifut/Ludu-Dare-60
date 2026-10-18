extends Node3D

signal on_score_overflow()

@onready var num_label: Label3D = %NumLabel

var _scrore: int

func _ready() -> void:
	_scrore = 0
	
	GameManager.on_game_start.connect(
		func():
			_scrore = 0
	)


func _process(_delta: float) -> void:
	num_label.text = str(_scrore)


func get_point() -> int:
	return _scrore


func add_point(point: int = 1):
	_scrore += point
	
	if _scrore > 9:
		_scrore = 0
		on_score_overflow.emit()
	
