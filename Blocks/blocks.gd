extends Node2D

@export var type : int = 1

@onready var changing_block = [$sprites/block3, $sprites/block4]

var is_actif = false
var move_direction = 1

func _ready():
	set_block_position()
	set_block_color()
	set_actif(true, 1)

func _process(delta):
	if is_actif:
		input_gestion()

func input_gestion():
	#rotate
	if Input.is_action_just_pressed("ui_accept"):
		rotation_degrees += 90
	
	# move
	if Input.is_action_just_pressed("ui_left"):
		move(-1*move_direction)
	elif Input.is_action_just_pressed("ui_right"):
		move(move_direction)

func move(direction):
	global_position += Vector2(32, 0) * direction
func go_down():
	global_position += Vector2(0, 32)

# 1 T, 2 Z, 3 I, 4 L, 5 O, 6 r, 7 S
func set_block_position():
	match type:
		1:
			changing_block[0].position = $sprites_position/pos1.position
			changing_block[1].position = $sprites_position/pos2.position
		2:
			changing_block[0].position = $sprites_position/pos1.position
			changing_block[1].position = $sprites_position/pos4.position
		3:
			changing_block[0].position = $sprites_position/pos5.position
			changing_block[1].position = $sprites_position/pos6.position
		4:
			changing_block[0].position = $sprites_position/pos1.position
			changing_block[1].position = $sprites_position/pos5.position
		5:
			changing_block[0].position = $sprites_position/pos2.position
			changing_block[1].position = $sprites_position/pos4.position
		6:
			changing_block[0].position = $sprites_position/pos2.position
			changing_block[1].position = $sprites_position/pos5.position
		7:
			changing_block[0].position = $sprites_position/pos2.position
			changing_block[1].position = $sprites_position/pos3.position

func set_block_color():
	for block in $sprites.get_children():
		block.set_color(type)

func set_actif(val, fall_speed):
	is_actif = val
	if val:
		$Timer.start(fall_speed)
	else:
		$Timer.stop()

func _on_timer_timeout():
	go_down()
