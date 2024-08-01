extends Node2D

class_name Blocks

@export var block_scene:PackedScene = load("res://Blocks/Block.tscn")

signal on_stop_falling(blocks:Blocks)

var fall_speed:float = 0.2
var is_falling:bool = false
var falling_direction:Vector2 = Vector2.DOWN

var _level:Level = null

var step:int = 32

var type:BLOCKS_TYPES = BLOCKS_TYPES.I_POSE

enum BLOCKS_TYPES {
	I_POSE,
	T_POSE,
	S_POSE,
	Z_POSE,
	O_POSE,
	L_POSE,
	J_POSE
}

var block_positions:Array = [
	[1, 4, 7, 10],
	[0, 1, 2, 4],
	[1, 2, 3, 4],
	[0, 1, 4, 5],
	[0, 1, 3, 4],
	[0, 1, 2, 3],
	[0, 1, 2, 5]
]

var block_rotations:Array = [
	2,
	1,
	1,
	1,
	0,
	1,
	1
]

var block_color:Array = [
	Color.SKY_BLUE,
	Color.MEDIUM_PURPLE,
	Color.YELLOW,
	Color.ORANGE,
	Color.WEB_GRAY,
	Color.BLUE,
	Color.SEA_GREEN
]

func set_blocks(val:int)->void:
	type = val as BLOCKS_TYPES
	_initialize_blocks()
	_initialize_rotation_center()
	_initialize_color()
	_start_falling()

func set_color(color:Color)->void:
	for block:Block in $Blocks.get_children():
		block.set_color(color)

func set_level(level:Level)->void:
	_level = level

func start()->void:
	pass

func get_blocks()->Array:
	var ar = []
	for block:Block in $Blocks.get_children():
		ar.append(block)
	return ar

# private methods
func _ready():
	randomize()
	set_blocks(randi()%7)

func _process(_delta):
	if is_falling:
		if Input.is_action_just_pressed("ui_up"):
			_rotate_left()
		if Input.is_action_just_pressed("ui_down"):
			_rotate_right()
		if Input.is_action_just_pressed("ui_left"):
			_move_left()
		if Input.is_action_just_pressed("ui_right"):
			_move_right()

func _start_falling()->void:
	is_falling = true
	$Timer.start(fall_speed)

func _initialize_blocks()->void:
	for value:int in block_positions[type]:
		var position_for_block = $BlockPositions.get_child(value).position
		_create_block_at(position_for_block)

func _create_block_at(position_for_block:Vector2)->void:
	var block = block_scene.instantiate()
	$Blocks.add_child(block)
	block.position = position_for_block

func _initialize_rotation_center()->void:
	var distance:Vector2 = $RotationPositions.get_child(block_rotations[type]).global_position - $Blocks.global_position
	$Blocks.position += distance
	for block in $Blocks.get_children():
		block.position -= distance

func _initialize_color()->void:
	set_color(block_color[type])

func _rotate_left()->void:
	$Blocks.rotate(-PI/2)
	if hit_limits():
		_rotate_right()

func _rotate_right()->void:
	$Blocks.rotate(PI/2)
	if hit_limits():
		_rotate_left()

func _move_left()->void:
	global_position += step*Vector2.LEFT
	if hit_limits():
		_move_right()

func _move_right()->void:
	global_position += step*Vector2.RIGHT
	if hit_limits():
		_move_left()

func hit_limits()->bool:
	if _level:
		for block in $Blocks.get_children():
			if _level.collide_with(block):
				return true
	return false

func _on_timer_timeout():
	fall()
	$Timer.start(fall_speed)

func fall()->void:
	global_position += step*falling_direction
	if hit_limits():
		global_position -= step*falling_direction
		is_falling = false
		on_stop_falling.emit(self)
