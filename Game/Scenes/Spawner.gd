extends Node

const SPAWN_X = 50
const EXTRA_LOWER_Y_BUFFER = 64

export (Resource)var resource
export (int)var y_buffer
export (float)var min_time
export (float)var time_range
var parent

var timer

func _ready():
	parent = get_parent()
	timer = rand_range(0.0, min_time + time_range)
	set_process(true)

func _process(delta):
	timer -= delta
	if timer < 0.0:
		timer = min_time + rand_range(0.0, time_range)
		spawn()

func spawn():
	var obj = resource.instance()
	obj.set_pos(Vector2(parent.SCREEN_SIZE_X + SPAWN_X  - parent.get_pos().x, rand_range(y_buffer, parent.SCREEN_SIZE_Y - y_buffer - EXTRA_LOWER_Y_BUFFER)))
	parent.add_child(obj)