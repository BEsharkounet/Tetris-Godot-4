extends Node2D

var speed = 0.2
@onready var blocks_scene = load("res://Blocks/blocks.tscn")
@onready var block_scene = load("res://Blocks/block.tscn")

func _ready():
	randomize()
	add_new()

func add_new():
	var new_type = randi()%7+1
	var new_block = blocks_scene.instantiate()
	new_block.set_type(new_type)
	$blocks.add_child(new_block)
	new_block.set_actif(true, speed)
	
	if new_type in [3, 5]:
		new_block.global_position = $FallPosition2.global_position
	else:
		new_block.global_position = $FallPosition1.global_position
		
	new_block.block_stopped.connect(block_placed)

func block_placed(blocks : CharacterBody2D) -> void:
	switch_block(blocks)
	add_new()

#remove block from blocks and put them directly ass child of level node "block"
#then delete the entity blocks
func switch_block(blocks : CharacterBody2D) -> void:
	for bl in blocks.get_all_block():
		var new_block = block_scene.instantiate()
		new_block.global_position = bl.global_position
		$block.insert(new_block)
		new_block.global_position = bl.global_position
		new_block.change_color(bl.get_color())
	$block.check_lines()
	blocks.queue_free()
