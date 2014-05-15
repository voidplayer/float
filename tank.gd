extends KinematicBody2D

export var tankid = "tank1"

#resources
var bullet = null
var track = null
var animation = null

#members
var angle = null
var anim = null
var shooting = false

#input
var up = null
var down = null
var rright = null
var rleft = null
var shoot = null

const MOTION_SPEED=160
const ROTATION_SPEED=4

func _process(delta):
	#debug
	if Input.is_action_pressed("debug"):
		get_parent().print_tree()
		
	# key definition
	if (tankid == "tank1"):
		up = Input.is_action_pressed("ui_up")
		down = Input.is_action_pressed("ui_down")
		rright = Input.is_action_pressed("ui_right")
		rleft = Input.is_action_pressed("ui_left")
		shoot = Input.is_action_pressed("shoot")
		
	elif (tankid == "tank2"):
		pass
	else:
		print("BUG: please asign id to tankid")

	angle = get_rot()
	
	# process actions
	var motion = Vector2()
	if (up):
		motion+=Vector2(-sin(angle),-cos(angle))
		set_anim("rolling")
		set_tracks()
		
	elif (down):
		motion+=Vector2(sin(angle),cos(angle))
		set_anim("rolling", true)
		set_tracks()

	else:
		set_anim("idle")
	
	if (rleft):
		angle += ROTATION_SPEED * delta
		set_rot(angle)
		set_tracks()
		
	if (rright):
		angle -= ROTATION_SPEED * delta
		set_rot(angle)
		set_tracks()

	if (shoot):
		shooting = true
		var bi = bullet.instance()
		bi.set_rot(angle)
		var pos = get_pos() + get_node("bulletPosition").get_pos()* Vector2(sin(angle),cos(angle))
		bi.set_pos(pos)
		get_parent().add_child(bi)
	
	motion = motion.normalized() * MOTION_SPEED * delta
	move(motion)
	
func set_tracks():
	var ti = track.instance()
	ti.set_pos(get_pos())
	ti.set_rot(get_rot())
	get_parent().add_child(ti)
	raise()


func set_anim(a, reverse = false):
	if anim != a:
		anim = a
		if !reverse:
			animation.play(anim)
		else:
			animation.play(anim, -1, -1, true)


func _ready():
	bullet = preload("res://bullet.xml")
	track = preload("res://track.xml")
	animation = get_node("Sprite/anim")
	set_anim("idle")
	
	set_process(true)
