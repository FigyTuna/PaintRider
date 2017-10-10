extends Node2D

var spawner_resource = preload("res://Scenes/Spawner.tscn")
var paint_ball_resource = preload("res://Scenes/PaintBall.tscn")
var star_resource = preload("res://Scenes/Star.tscn")
var speed_up_resource = preload("res://Scenes/SpeedUp.tscn")

var button_down = false
export (NodePath)var guy_path
onready var guy = get_node(guy_path)
export (NodePath)var status_path
onready var status = get_node(status_path)
onready var sfx_player = get_node("SamplePlayer")
onready var spray_sfx_player = get_node("SamplePlayerSpray")
onready var anim_player = get_node("AnimationPlayer")

const PAINT_TIME = 0.01
const PAINT_BALL_DISTANCE = 30
const PAINT_BALL_ROTATION = 0.1
const BASE_SPEED = 6.0
const SLOW_DOWN = 0.9995
const SPEED_UP = 1.01
const PAINT_USE = 15
const UPDATE_TIME = 1
const BACKGROUND_WIDTH = 4000
const SCREEN_SIZE_X = 1024
const SCREEN_SIZE_Y = 600

var speed = BASE_SPEED
var max_speed = speed
var paint_timer = 0.0
var update_timer = 0.0

var star_spawner
var speed_up_spawner
var dead = false

func _ready():
	set_fixed_process(true)

func set_button_down(down):
	button_down = down
	if down:
		paint_timer = 0
		spray_sfx_player.play("spray")
	else:
		spray_sfx_player.stop_all()

func _fixed_process(delta):
	
	if dead and not anim_player.is_playing():
		get_tree().change_scene("res://Scenes/Start.tscn")
	
	update_timer += delta
	if update_timer > UPDATE_TIME:
		update_timer = 0.0
		update_old()
	
	if should_paint():
		if not spray_sfx_player.is_active():
			spray_sfx_player.play("spray")
		status.use_paint(delta * PAINT_USE)
		paint_timer += delta
		if paint_timer > PAINT_TIME:
			spawn_paint()
			paint_timer = 0
	else:
		if spray_sfx_player.is_active():
			spray_sfx_player.stop_all()
	
	max_speed *= SLOW_DOWN
	speed *= SPEED_UP
	if speed > max_speed:
		speed = max_speed
	if max_speed < BASE_SPEED:
		max_speed = BASE_SPEED
	
	if not dead:
		set_pos(Vector2(get_pos().x - speed, get_pos().y))

func spawn_paint():
	var ball = paint_ball_resource.instance()
	var x = -sin(guy.get_brush_rotation() + PAINT_BALL_ROTATION)
	var y = -cos(guy.get_brush_rotation() + PAINT_BALL_ROTATION)
	ball.set_pos(Vector2(guy.get_pos().x + PAINT_BALL_DISTANCE * x, guy.get_pos().y + PAINT_BALL_DISTANCE * y))
	add_child(ball)

func should_paint():
	return button_down and guy.get_pos().y >= 0 and status.paint > 0 and not dead

func speed_up():
	max_speed += 4

func update_old():
	global.num_items = get_child_count()
	
	var background = get_node("Background")
	if -background.get_pos().x - get_pos().x > BACKGROUND_WIDTH / 2:
		background.set_pos(Vector2(background.get_pos().x + BACKGROUND_WIDTH / 2, background.get_pos().y))
	
	for child in get_children():
		if child.has_method("on_offscreen"):
			child.on_offscreen(get_pos().x)

func play_sfx(sound):
	sfx_player.play(sound)

func die():
	if not dead:
		global.check_high_score(status.score)
		get_node("Curtain").set_pos(Vector2(-get_pos().x, 0))
		get_node("StreamPlayer").stop()
		anim_player.play("die")
		dead = true
		play_sfx("die")