extends Node2D

class_name Block

var falling_direction:Vector2 = Vector2.DOWN
var step:int = 32
var exists:bool = true

func set_color(color:Color)->void:
	$Sprite2D.modulate = color

func get_color()->Color:
	return $Sprite2D.modulate

func collide_with(block:Block)->bool:
	return block.global_position.distance_to(global_position) < 10

func fall()->void:
	global_position += step*falling_direction
