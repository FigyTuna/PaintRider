extends Node2D

const WAITING_SCORE = 5
const WAIT_TIME = 1

var wait_timer = 0.0

onready var paint_holder = get_node("PaintHolder")
onready var status = get_node("Status")

func _ready():
	randomize()
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.type == InputEvent.KEY:
		if event.is_action_pressed("game_primary") and not paint_holder.button_down:
			paint_holder.set_button_down(true)
		elif event.is_action_released("game_primary") and paint_holder.button_down:
			paint_holder.set_button_down(false)

func _process(delta):
	wait_timer += delta + delta * 0.5 * (paint_holder.speed - paint_holder.BASE_SPEED)
	if wait_timer > WAIT_TIME and not paint_holder.dead:
		wait_timer = 0
		status.add_score(WAITING_SCORE)