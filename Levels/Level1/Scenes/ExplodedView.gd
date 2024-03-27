extends Node2D

var angle = -30.0
func _ready():
	$Line.rect_rotation = angle
	for i in range(8):
		var x = i * ($Line.rect_size.x / 7) * cos(PI * angle / 180)
		var y = i * ($Line.rect_size.x / 7) * sin(PI * angle / 180)
		
		get_child(i+1).position = $Line.rect_position + Vector2(x, y)
		get_child(i+1).order = 10 - i

func NumFree():
	var count = 8
	
	for i in range(8):
		if get_child(i+1).Full():
			count -= 1

	return count
