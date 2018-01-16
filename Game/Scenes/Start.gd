extends Control

func _ready():
	var global = get_node("/root/global")
	global.load_high_score()
	set_process_input(true)
	var high_score = global.high_score
	if high_score > 0:
		get_node("HighScore").set_text("High Score: " + str(high_score))
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		get_node("Button").set_text("Touch to start!")

func _on_start_pressed():
	start_game()

func _input(event):
	if event.type == InputEvent.KEY:
		if event.is_action_pressed("game_primary"):
			start_game()
	if event.type == InputEvent.SCREEN_TOUCH:
		start_game()

func start_game():
	get_tree().change_scene("res://Scenes/MainScene.tscn")