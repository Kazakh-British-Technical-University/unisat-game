extends Node2D

export var title = "Plot title"
export var step = 10
var offset = Vector2(50, 50)
var offset2 = Vector2(20, 0)
var width = 350
var height = 250

func _ready():
	$Title.text = title

func DrawLine(data):
	min_x = 0
	max_x = data.size()
	
	var line = $LineContainer/Line2D as Line2D
	
	width = $LineContainer.rect_size.x - offset.x- offset2.x
	height = $LineContainer.rect_size.y - offset.y - offset2.y
	
	for i in data.size():
		var x = lerp(0, width, float(i) / max_x)
		var y = lerp(0, height, (float(data[i])-min_y) / (max_y-min_y))
		
		line.add_point(Vector2(x, height - y) + offset)
		if i % 5 == 0:
			yield(get_tree().create_timer(0.01),"timeout")
	
	$"..".Finished()

func SetMinMax(_min_y, _max_y):
	min_y = _min_y
	max_y = _max_y

var min_x = 0
var max_x = 0
var min_y = 100000
var max_y = -100000
