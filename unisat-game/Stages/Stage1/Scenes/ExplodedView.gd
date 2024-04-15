extends Node2D

var socketPrefab = preload("res://Stages/Stage1/Scenes/PartSlot.tscn")
var angle = -30.0
var count = 8

func SetLine():
	$Line.rect_rotation = angle
	for i in range(count):
		var x = i * ($Line.rect_size.x / (count-1)) * cos(PI * angle / 180)
		var y = i * ($Line.rect_size.x / (count-1)) * sin(PI * angle / 180)
		
		get_child(i+1).position = $Line.rect_position + Vector2(x, y)
		get_child(i+1).order = 10 - i

func SetupSockets(dragManager : Node2D):
	count = dragManager.get_child_count() - 1
	print(count)
	for i in range(1, dragManager.get_child_count()):
		var socket = socketPrefab.instance()
		socket.name = "PartSlot" + str(i-1)
		socket.part_name = dragManager.get_child(i).part_name
		add_child(socket)
	SetLine()

func NumFree():
	var fulls = count
	for i in range(count):
		if get_child(i+1).Full():
			fulls -= 1

	return fulls
