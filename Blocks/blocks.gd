extends CharacterBody2D

@export var type : int = 1

@onready var changing_block = [$block3, $block4]

signal block_stopped(blocks)

var is_actif = false

func _ready():
	set_block_position()
	set_block_color()

func _physics_process(delta):
	if is_actif:
		input_gestion()

func input_gestion():
	#rotate
	if Input.is_action_just_pressed("ui_accept"):
		rotate_blocks(90)
	
	# move
	if Input.is_action_just_pressed("ui_left"):
		move(Vector2(-32, 0))
	elif Input.is_action_just_pressed("ui_right"):
		move(Vector2(32, 0))

func rotate_blocks(angle):
	var initial_position = global_position
	rotation_degrees += angle
	var hit = move_and_collide(Vector2())
	global_position = initial_position
	if hit != null:
		rotation_degrees -= angle

func get_all_block() -> Array:
	var arr = []
	for child in get_children():
		if child.is_in_group("block"):
			arr.append(child)
	return arr

func move(direction, is_killer = false):
	var initial_position = global_position
	var hit = move_and_collide(direction)
	if hit != null:
		global_position = initial_position
		if is_killer:
			set_actif(false)
			emit_signal("block_stopped", self)

func set_block_color():
	for child in get_children():
		if child.is_in_group("block"):
			child.set_color(type)

func set_actif(val, fall_speed = 1):
	is_actif = val
	if val:
		$Timer.start(fall_speed)
	else:
		for child in get_children():
			if child.is_in_group("block"):
				child.explode()
		$Timer.stop()

func set_type(new_type:int) -> void:
	type = new_type

func _on_timer_timeout():
	move(Vector2(0, 32), true)

func change_center_position(pos:Vector2) -> void:
	for child in get_children():
		if child.is_in_group("block"):
			child.position -= pos

# 1 T, 2 Z, 3 I, 4 L, 5 O, 6 r, 7 S
func set_block_position():
	match type:
		1:
			changing_block[0].position = $sprites_position/pos1.position
			changing_block[1].position = $sprites_position/pos2.position
			change_center_position($rotation_center/center1.position)
		2:
			changing_block[0].position = $sprites_position/pos1.position
			changing_block[1].position = $sprites_position/pos4.position
			change_center_position($rotation_center/center2.position)
		3:
			changing_block[0].position = $sprites_position/pos5.position
			changing_block[1].position = $sprites_position/pos6.position
			change_center_position($rotation_center/center3.position)
		4:
			changing_block[0].position = $sprites_position/pos1.position
			changing_block[1].position = $sprites_position/pos5.position
			change_center_position($rotation_center/center4.position)
		5:
			changing_block[0].position = $sprites_position/pos2.position
			changing_block[1].position = $sprites_position/pos4.position
			change_center_position($rotation_center/center5.position)
		6:
			changing_block[0].position = $sprites_position/pos2.position
			changing_block[1].position = $sprites_position/pos5.position
			change_center_position($rotation_center/center6.position)
		7:
			changing_block[0].position = $sprites_position/pos2.position
			changing_block[1].position = $sprites_position/pos3.position
			change_center_position($rotation_center/center7.position)
