extends KinematicBody2D

var motion
var pos
var tank_class = preload("res://tank.xml")

const BULLET_SPEED = 200

func _fixed_process(delta):
	var angle = get_rot()
	if (is_colliding()):
		var body = get_collider()
		#if body extends tank_class:
		body.hit()
		queue_free()
	#var pos = get_pos()
	#print("pos: ", pos," angle: ",angle," sin(angle): ", sin(angle), " delta: ", delta)
	motion = BULLET_SPEED * Vector2(-sin(angle),-cos(angle)) * delta
	#set_pos(pos + motion)
	move(motion)

func _ready():
	set_fixed_process(true)

func _on_Timer_timeout():
	queue_free()
