extends Node2D

onready var fileName = "res://Data/test.txt"
var max_alt = 3000
func _ready():
	pass

var temp = []
var altitude = []
var PM25 = []
var PM10 = []
 
func load_file():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var offset = 0
	var i = 0
	var dir = 1
	
	var f = File.new()
	f.open(fileName, File.READ)
	f.get_csv_line()
	
	while not f.eof_reached():
		i += 1
		var values = Array(f.get_csv_line())
		if (values.size() > 1):
			if i % 10 == 0:
				offset += dir * rng.randf_range(0, 1)
				if offset < 0:
					dir = -dir
					offset = 0
				elif offset > 1:
					dir = -dir
					offset = 1

			#altitude.append(offset)
			
			temp.append(float(values[1]) + offset * 0.5)
			PM25.append(clamp(float(values[2]) + offset * 5, 0, 1000))
			PM10.append(clamp(float(values[3]) + offset * 20, 0, 1000))
			altitude.append(max_alt * (1 - exp(-5*float(temp.size()) / 2206.0)))
	f.close()


func _on_StartButton_pressed():
	$StartPopup.visible = false
	
	load_file()
	$Chart1.SetMinMax(-50, 30)
	$Chart1.DrawLine(temp)
	
	$Chart2.SetMinMax(0, 70)
	$Chart2.DrawLine(PM25)
	
	$Chart3.SetMinMax(0, 350)
	$Chart3.DrawLine(PM10)
	
	$Chart4.SetMinMax(0, 3000)
	$Chart4.DrawLine(altitude)

func Finished():
	$EndPopup.visible = true

func _on_EndButton_pressed():
	$QuestionPanel.visible = true
	$EndPopup.visible = false
