extends Node3D


@onready var menu_canvas_layer: CanvasLayer = %MenuCanvasLayer
@onready var play: VBoxContainer = %Play
@onready var life_progress_bar: ProgressBar = %LifeProgressBar
@onready var score_label: Label = %ScoreLabel

@onready var pinball: Pinball = %Pinball

@onready var how_to_camera: Camera3D = %HowToCamera
@onready var main_camera: Camera3D = %MainCamera
@onready var move_camera: Camera3D = %MoveCamera

@onready var start_button: Button = %StartButton
@onready var how_to_button: Button = %HowToButton
@onready var quit_button: Button = %QuitButton
@onready var back_to_button: Button = %BackToButton



func _ready() -> void:
	randomize()
	
	move_camera.make_current()
	
	GameManager.on_malfunction_puls.connect(
		func():
			life_progress_bar.value -= 10.0
			if life_progress_bar.value <= 0.0:
				GameManager.on_game_stop.emit()
				pinball.stop()
	)
	
	GameManager.on_add_point.connect(
		func():
			if life_progress_bar.value < 100.0:
				life_progress_bar.value += 1.0
	)


func _on_start_button_pressed() -> void:
	GameManager.on_game_start.emit()
	life_progress_bar.value = 100.0
	menu_canvas_layer.hide()
	play.show()


func _on_pinball_on_game_over(_score: int) -> void:
	score_label.text = "Score: " + str(_score)
	play.hide()
	menu_canvas_layer.show()
	move_camera.make_current()


func _on_quit_button_pressed() -> void:
	get_tree().quit()



func _on_how_to_button_pressed() -> void:
	start_button.hide()
	how_to_button.hide()
	quit_button.hide()
	score_label.hide()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property(move_camera, "global_transform", how_to_camera.global_transform, 1.0)
	tween.tween_property(move_camera, "fov", how_to_camera.fov, 1.0)
	
	await tween.finished
	back_to_button.show()


func _on_back_to_button_pressed() -> void:
	back_to_button.hide()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel()
	tween.tween_property(move_camera, "global_transform", main_camera.global_transform, 1.0)
	tween.tween_property(move_camera, "fov", main_camera.fov, 1.0)
	
	await tween.finished
	start_button.show()
	how_to_button.show()
	quit_button.show()
	score_label.show()
