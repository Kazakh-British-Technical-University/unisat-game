extends Node2D

export var step = 10
var offset = Vector2(63, 77)
var width = 322.0
var height = 162.0

var dataset

func SetTitle(title):
	$Title.text = title

func DrawLine(data, increment):
	dataset = data
	min_x = 0
	max_x = data.size()
	max_y = ceil(data.max() / increment) * increment
	if (data.min() < 0):
		min_y = -ceil(-data.min() / increment) * increment
	else:
		min_y = floor(data.min() / increment) * increment
	
	for i in range(6):
		$xTicks.get_child(i).text = str((5 - i) * ((max_y - min_y) / 5) + min_y)
	
	var line = $Grid/Line2D as Line2D
	
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
	for i in range(6):
		$xTicks.get_child(i).text = str((5 - i) * ((max_y - min_y) / 5) + min_y)

var min_x = 0
var max_x = 0
var min_y = 100000
var max_y = -100000

func ShowSlider():
	$SelectorLine.visible = true
	MoveSlider(0)

func MoveSlider(t):
	var ind = min(round(t * dataset.size()), dataset.size()-1)
	var curValue = (dataset[ind] - min_y) / (max_y - min_y)
	var curTime = (ind - min_x) / (dataset.size() - min_x)
	$SelectorLine.position = Vector2(offset.x + lerp(0, width, curTime), 155)
	$SelectorLine/Value.position = Vector2(0, lerp(85, -offset.y, curValue))
	$SelectorLine/Value/SelectorLabel/Label.text = str(round(dataset[ind]))
