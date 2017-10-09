extends "res://Item.gd"

func do_collision_effect(status, paint_holder):
	status.add_score(50)
	paint_holder.play_sfx("star")
	get_node("AnimationPlayer").play("Spin")
