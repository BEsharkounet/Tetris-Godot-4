extends CollisionShape2D

func _ready():
	pass

func explode():
	change_color(Color(1, 1, 1, 1), 0.5)

func get_color() -> Color:
	return $sprite.modulate

func change_color(color:Color, speed:float=0):
	var tween = create_tween()
	tween.tween_property($sprite, "modulate", color, speed)

func set_color(val: int):
	if val == 1: # 1 Light Blue
		change_color(Color(0.39, 0.59, 1, 1))
	elif val == 2: # 2 Yellow
		change_color(Color(1, 0.78, 0, 1))
	elif val == 3: # 3 Light Green
		change_color(Color(0, 0.78, 0.39, 1))
	elif val == 4: # 4 Orange
		change_color(Color(1, 0.55, 0, 1))
	elif val == 5: # 5 Pink
		change_color(Color(1, 0.39, 0.59, 1))
	elif val == 6: # 6 Purple
		change_color(Color(0.59, 0, 1, 1))
	else: # 7 Light Grey
		change_color(Color(0.59, 0.59, 0.59, 1))
