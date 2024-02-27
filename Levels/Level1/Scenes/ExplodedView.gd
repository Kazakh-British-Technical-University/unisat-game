extends Node2D

var angle = -30.0
func _ready():
	$Line.rect_rotation = angle
	for i in range(0, 9):
		var x = i * ($Line.rect_size.x / 8) * cos(PI * angle / 180)
		var y = i * ($Line.rect_size.x / 8) * sin(PI * angle / 180)
		
		get_child(i+1).position = $Line.rect_position + Vector2(x, y)
		get_child(i+1).order = 10 - i

func NumFree():
	var count = 9
	
	for i in range(0, 9):
		if get_child(i+1).Full():
			count -= 1

	return count
