extends Node2D

class_name Level

@export var blocks_for_line:int = 9

@onready var blocks_scene:PackedScene = load("res://Blocks/Blocks.tscn")
@onready var block_scene:PackedScene = load("res://Blocks/Block.tscn")

func _ready():
	spawn()

func collide_with(block:Block)->bool:
	return collide_with_walls(block) or collide_with_singleblocks(block)

func collide_with_singleblocks(block:Block)->bool:
	for singleblock:Block in $SingleBlocks.get_children():
		if singleblock.collide_with(block):
			return true
	return false

func collide_with_walls(block:Block)->bool:
	for wall:Block in $Walls.get_children():
		if wall.collide_with(block):
			return true
	return false

func spawn()->void:
	if $Spawner/Area2D.get_overlapping_areas().size() > 0:
		for block in $SingleBlocks.get_children():
			block.set_color(Color.FIREBRICK)
	else:
		var blocks:Blocks = blocks_scene.instantiate()
		blocks.global_position = $Spawner.global_position
		blocks.set_level(self)
		$GroupBlocks.add_child(blocks)
		blocks.on_stop_falling.connect(Callable(self, "on_stop_falling_emit"))

func on_stop_falling_emit(blocks:Blocks)->void:
	transfer_blocks(blocks)
	blocks.queue_free()
	spawn()

func transfer_blocks(blocks:Blocks)->void:
	var singleblocks = blocks.get_blocks()
	var added_blocks:Array = []
	for signleblock:Block in singleblocks:
		var block = block_scene.instantiate()
		block.global_position = signleblock.global_position
		block.set_color(signleblock.get_color())
		$SingleBlocks.add_child(block)
		
		var is_new_line:bool = true
		for element in added_blocks:
			if abs(element.global_position.y - block.global_position.y) < 10:
				is_new_line = false
		if is_new_line:
			added_blocks.append(block)
	check_lines(added_blocks)

func check_lines(blocks:Array)->void:
	var lines_y:Array = []
	for block in blocks:
		var same_line_blocks:Array = []
		for singleblock:Block in $SingleBlocks.get_children():
			if abs(singleblock.global_position.y - block.global_position.y) < 10:
				same_line_blocks.append(singleblock)
		
		if len(same_line_blocks) >= blocks_for_line:
			lines_y.append(same_line_blocks[0].global_position.y)
			for singleblock in same_line_blocks:
				singleblock.queue_free()
	fall(lines_y)

func fall(lines_y:Array)->void:
	for singleblock:Block in $SingleBlocks.get_children():
		var counter:int = 0
		for line in lines_y:
			if singleblock.global_position.y < line:
				counter += 1
				
		singleblock.fall(counter)
