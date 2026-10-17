extends Node3D


@onready var menu_canvas_layer: CanvasLayer = %MenuCanvasLayer


func _ready() -> void:
	randomize()


func _on_start_button_pressed() -> void:
	GameManager.on_game_start.emit()
	menu_canvas_layer.hide()


func _on_pinball_on_game_over(score: int) -> void:
	GameManager.on_game_stop.emit()
	menu_canvas_layer.show()
