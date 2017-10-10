extends Area2D

const START_POS = Vector2(200, 50)
const RISE_ROTATION = 0.5

const GRAVITY = 1200.0
const UPWARDS_FORCE = 3
const LOWER_BOUND = 45
const VISUAL_SPEED = 1
const VISUAL_SPEED_DISTANCE = 70
var velocity = Vector2(0, 0)
var rising = false
var actual_x = START_POS.x
var visual_x = 0.0

export (NodePath)var paint_holder_path
onready var paint_holder = get_node(paint_holder_path)
export (NodePath)var status_path
onready var status = get_node(status_path)
export (Texture)var fall_texture
export (Texture)var rise_texture

onready var global = get_node("/root/global")

func _ready():
	set_pos(START_POS)
	set_fixed_process(true)
	set_process(true)
	global.material = get_node("Sprite").get_material()
	global.game_start()

func _process(delta):
	if get_pos().y > paint_holder.SCREEN_SIZE_Y + LOWER_BOUND:
		paint_holder.die()

func _fixed_process(delta):
	actual_x = START_POS.x - paint_holder.get_pos().x
	visual_x += VISUAL_SPEED
	var target_x = (paint_holder.speed - paint_holder.BASE_SPEED) * VISUAL_SPEED_DISTANCE
	if visual_x > target_x:
		visual_x = target_x
	
	look_at(velocity + Vector2(visual_x + 800, 0))
	set_pos(Vector2(actual_x + visual_x, get_pos().y))
	velocity.y += delta * GRAVITY
	var motion = velocity * delta
	var sprite = get_node("Sprite")
	
	if paint_holder.should_paint():
		velocity.y -= delta * GRAVITY * UPWARDS_FORCE
		if not rising:
			rising = true
			sprite.set_texture(rise_texture)
			sprite.set_rot(RISE_ROTATION - 90)
	else:
		if rising:
			rising = false
			sprite.set_texture(fall_texture)
			sprite.set_rot(-90)
	
	set_pos(get_pos() + motion)

func _on_area_enter(area):
	if area.has_method("do_collision_effect"):
		area.do_collision_effect(status, paint_holder)

func get_brush_rotation():
	return get_rot() + RISE_ROTATION
