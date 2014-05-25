extends KinematicBody2D

export var tankid = "p1"
export var tankcolor = "green"

const MOTION_SPEED=160
const ROTATION_SPEED=4
const CAN_SHOOT=1
const CAN_PUT_TRACK=0.05
const LIVES=3

#resources
var bullet = null
var track = null
var animation = null
var scoreboard = null
var global = null

#members
var angle = null
var anim = null
var can_shoot = CAN_SHOOT
var can_put_track = CAN_PUT_TRACK
var lives = LIVES

#input
var up = null
var down = null
var rright = null
var rleft = null
var shoot = null


func _fixed_process(delta):
	#update variables that keep track of time
	can_shoot -= delta
	can_put_track -= delta
	
	#if is_colliding():
		#print(get_collider())
	#debug
	if Input.is_action_pressed("debug"):
		get_parent().print_tree()

	if Input.is_action_pressed("ui_cancel"):
		global.goto_scene("res://title.xml")

	# key definition
	up = Input.is_action_pressed(tankid + "up")
	down = Input.is_action_pressed(tankid + "down")
	rright = Input.is_action_pressed(tankid + "right")
	rleft = Input.is_action_pressed(tankid + "left")
	shoot = Input.is_action_pressed(tankid + "shoot")

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

	elif (anim != "hit"):
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
		shoot()

	# update tank motion
	motion = motion.normalized() * MOTION_SPEED * delta
	move(motion)

func shoot():
	if can_shoot <= 0:
		can_shoot = CAN_SHOOT
		var bi = bullet.instance()
		bi.set_rot(angle)
		var pos = get_pos() + get_node("Sprite/bulletPosition").get_pos()* Vector2(sin(angle),cos(angle))
		bi.set_pos(pos)
		
		#dont collide with own tank
		PS2D.body_add_collision_exception(bi.get_rid(),get_rid())
		
		get_parent().add_child(bi)

func set_tracks():
	if can_put_track <= 0:
		can_put_track = CAN_PUT_TRACK
		var ti = track.instance()
		ti.set_pos(get_pos())
		ti.set_rot(get_rot())
		get_parent().add_child(ti)
		raise()


func set_anim(a, reverse = false):
	if anim != a:
		anim = a
		if !reverse:
			#print(tankid, " ", anim)
			if anim == "hit":
				animation.queue(tankcolor + " " + anim)
			else:
				animation.play(tankcolor + " " + anim)
		else:
			animation.play(tankcolor + " " + anim, -1, -1, true)

func hit():
	#set_anim("hit")
	if lives > 0:
		lives -= 1

	#update scoreboard
	update_scoreboard()

func update_scoreboard():
	scoreboard.set_lives(tankid, lives)

func _ready():
	print("tank ready")
	bullet = preload("res://bullet.xml")
	track = preload("res://track.xml")
	global = get_node("/root/global")

	animation = get_node("Sprite/anim")
	set_anim("idle")
	
	scoreboard = get_parent().get_node("scoreboard")
	assert (scoreboard)
	update_scoreboard()

	set_fixed_process(true)


func _on_Area2D_body_enter( body ):
	print(body)
