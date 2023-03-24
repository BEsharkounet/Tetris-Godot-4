extends StaticBody2D

@export var block_for_one_line = 9
var lines = []
var explosions_y = []

func insert(block:CollisionShape2D) -> void:
	add_child(block)
	var y = round(block.global_position.y)
	print(str("insert at ", y))
	var added = false
	for line in lines:
		if line[0] == y:
			line[1].append(block)
			added = true
	if not added:
		lines.append([y, [block]])
		print()

func check_lines() -> void:
	var combo = 0
	explosions_y = []
	var i = 0
	while i < lines.size():
		if lines[i][1].size() >= block_for_one_line:
			explosion(lines[i], i)
			combo += 1
		else:
			i += 1
	if combo > 0:
		go_down()

func go_down() -> void:
	for line in lines:
		var count = 0
		for removed_y in explosions_y:
			if removed_y > line[0]:
				count += 1
		move_line(line, count*32)

func move_line(line, y:int) -> void:
	line[0] += y
	for block in line[1]:
		block.global_position.y += y

func explosion(line, index:int) -> void:
	explosions_y.append(line[0])
	for block in line[1]:
		block.queue_free()
	lines.remove_at(index)
