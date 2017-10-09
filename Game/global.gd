extends Node

const colors = [Color(0,0,0), Color(1,0,0), Color(0,1,0), Color(0,0,1), Color(1,1,0), Color(1,0,1), Color(0,1,1)]
const textures = [preload("res://Images/Paint/black.png"), preload("res://Images/Paint/red.png"), preload("res://Images/Paint/green.png"), preload("res://Images/Paint/blue.png"), preload("res://Images/Paint/yellow.png"), preload("res://Images/Paint/magenta.png"), preload("res://Images/Paint/cyan.png")]
const SAVE_LOCATION = "user://save.json"

const MAX_ITEMS =  4000
const LOOPS = true

var material

var high_score = 0

var color1;

var num_items

func game_start():
	color1 = 0
	set_colors()

func set_colors():
	material.set_shader_param("c", colors[color1])

func pick_second_color():
	var chosen_color = randi() % colors.size()
	material.set_shader_param("c2", colors[chosen_color])
	return chosen_color

func change_color(chosen_color):
	color1 = chosen_color
	set_colors()

func get_paint_texture():
	return textures[color1]

func delete_color():
	return (not LOOPS) or rand_range(0, MAX_ITEMS) < num_items

func check_high_score(score):
	if score > high_score:
		high_score = score
		
		var dict = {"high_score":high_score}
		
		var file = File.new()
		file.open(SAVE_LOCATION, File.WRITE)
		file.store_line(dict.to_json())
		file.close()

func load_high_score():
	var file = File.new()
	if  file.file_exists(SAVE_LOCATION):
		file.open(SAVE_LOCATION, File.READ)
		var results = {}
		results.parse_json(file.get_as_text())
		high_score = results["high_score"]
	