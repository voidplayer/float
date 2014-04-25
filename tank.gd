
extends KinematicBody2D

# member variables here, example:
# var a=2
# var b="textvar"

const MOTION_SPEED=160

func _fixed_process(delta):

	var motion = Vector2()
	
	if (Input.is_action_pressed("ui_up")):
		motion+=Vector2(0,-1)
	if (Input.is_action_pressed("ui_down")):
		motion+=Vector2(0,1)
	if (Input.is_action_pressed("ui_left")):
		motion+=Vector2(-1,0)
	if (Input.is_action_pressed("ui_right")):
		motion+=Vector2(1,0)
	
	motion = motion.normalized() * MOTION_SPEED * delta
	move(motion)
	

func _ready():
	# Initalization here
	set_fixed_process(true)
	pass
