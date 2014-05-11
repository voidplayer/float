extends KinematicBody2D

var motion

const BULLET_SPEED = 200

func _process(delta):
	var angle = get_rot()
	#print("pos: ", pos," angle: ",angle," sin(angle): ", sin(angle), " delta: ", delta)
	motion = BULLET_SPEED * Vector2(-sin(angle),-cos(angle)) * delta
	move(motion)
	var t = get_transform()
	#print ("transform: ", t)

func _ready():
	set_process(true)
	pass
	

func _on_Timer_timeout():
	queue_free()
