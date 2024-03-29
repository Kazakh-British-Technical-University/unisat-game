extends Node2D

export var web = false

var dataFolder = "res://Data/"
var jsonPath = ""
var csvPath = ""

var _my_js_callback = JavaScript.create_callback(self, "ProcessResponse")
var _csv_callback = JavaScript.create_callback(self, "ProcessCSV")
var externalator = JavaScript.get_interface("externalator")
var window = JavaScript.get_interface("window")

func _ready():
	if global.externalator_initated:
		return
	global.externalator_initated = true
	
	if web:
		externalator.addGodotFunction('SendToGodot',_my_js_callback)
		externalator.addGodotFunction('SendCSV',_csv_callback)

func LoadJSON(filename):
	jsonPath = dataFolder + filename
	
	if web:
		JSONfromWeb()
	else:
		JSONfromFile()

func JSONfromFile():
	var file = File.new()
	if file.open(jsonPath, File.READ) == OK:
		var content = file.get_as_text()
		file.close()
		
		ParseJSON(content)
	else:
		print("JSON read error " + jsonPath)
		return null

func JSONfromWeb():
	var webPath = jsonPath
	webPath.erase(0, 5)
	webPath = "." + webPath
	window.fetchJSONData(webPath)
	
func ProcessResponse(args):
	#print("From Godot: received message: " + str(args[0]))
	ParseJSON(str(args[0]))

func ParseJSON(json : String):
	var parsed = JSON.parse(json).result
	if (parsed != null):
		$"..".Result(parsed)
	else:
		print("JSON parse error " + jsonPath)


func LoadCSV(filename):
	csvPath = dataFolder + filename
	if web:
		csvPath += ".csv"
		CSVfromWeb()
	else:
		csvPath += ".txt"
		CSVfromFile()

func CSVfromFile():
	var lines = []
	var f = File.new()
	f.open(csvPath, File.READ)
	while not f.eof_reached():
		lines.append(f.get_line())
	f.close()
	ExtractCSVdata(lines)

func CSVfromWeb():
	var webPath = csvPath
	webPath.erase(0, 5)
	webPath = "." + webPath
	window.fetchCSV(webPath)

func ProcessCSV(args):
	var data = str(args[0])
	var lines = data.split("\n")
	ExtractCSVdata(lines)

func ExtractCSVdata(lines):
	var sensorData = []
	var sensor1 : Dictionary
	var sensor2 : Dictionary
	var sensor3 : Dictionary
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var offset = 0
	var dir = 1
	
	var sensorLabels = str(lines[0]).split(",")
	
	sensor1["Label"] = sensorLabels[0]
	sensor1["Data"] = []
	sensor2["Label"] = sensorLabels[1]
	sensor2["Data"] = []
	sensor3["Label"] = sensorLabels[2]
	sensor3["Data"] = []
	
	for i in range(1, lines.size()):
		var values = str(lines[i]).split(",")
		
		#print(values)
		if (values.size() > 1):
			if i % 10 == 0:
				offset += dir * rng.randf_range(0, 1)
				if offset < 0:
					dir = -dir
					offset = 0
				elif offset > 1:
					dir = -dir
					offset = 1
			offset = 0
			sensor1["Data"].append(float(values[0]) + offset * 0.5)
			sensor2["Data"].append(clamp(float(values[1]) + offset * 5, 0, 1000))
			sensor3["Data"].append(clamp(float(values[2]) + offset * 20, 0, 1000))
			
	sensorData.append(sensor1)
	sensorData.append(sensor2)
	sensorData.append(sensor3)
	
	$"..".SetCSV(sensorData)
