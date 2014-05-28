extends KinematicBody2D

var motion
var pos
var tank_class = preload("res://tank.gd")

var hitted = false

const BULLET_SPEED = 200

func _fixed_process(delta):
	var angle = get_rot()
	if (is_colliding() and ! hitted):
		hitted = true
		var body = get_collider()
		if body extends tank_class:
			body.hit()
		#queue_free()

		var anim = get_node("Sprite/anim")
		if !anim.is_playing():
			anim.play("hit")

	#hax because function of anim does not work
	if hitted and ! get_node("Sprite/anim").is_playing():
		queue_free()


	if !hitted:
		motion = BULLET_SPEED * Vector2(-sin(angle),-cos(angle)) * delta
		move(motion)

func _ready():
	set_fixed_process(true)

func _on_Timer_timeout():
	queue_free()

#this function is not working... therefore the hax in line 24
func hit():
	print("hit")
	queue_free()
