extends Control

const MAX_PAINT = 100.0

var score = 0
var paint = MAX_PAINT

func _ready():
	display_score()
	update_paint_bar()

func add_score(amount):
	score += amount
	display_score()

func refill_paint():
	paint = MAX_PAINT
	update_paint_bar()

func use_paint(amount):
	paint -= amount
	update_paint_bar()

func update_paint_bar():
	get_node("Paint").set_value(paint)

func display_score():
	get_node("Score").set_text("Score: " + str(score))