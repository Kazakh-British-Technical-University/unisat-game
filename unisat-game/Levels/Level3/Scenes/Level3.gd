extends Node2D

var sensorData = []

var max_alt = 3000

var altitude = []

func Start():
	$Chart1.SetTitle(global.local("ALTITUDE"))
	$Chart1.DrawLine(altitude, 100)
	$Chart2.SetTitle(sensorData[0]["Label"])
	$Chart2.DrawLine(sensorData[0]["Data"], 10)
	$Chart3.SetTitle(sensorData[1]["Label"])
	$Chart3.DrawLine(sensorData[1]["Data"], 10)
	$Chart4.SetTitle(sensorData[2]["Label"])
	$Chart4.DrawLine(sensorData[2]["Data"], 10)

func Finished():
	global.SFX(1)
	$QuestionPanel.visible = true
	$Slider.visible = true
	$Chart1.ShowSlider()
	$Chart2.ShowSlider()
	$Chart3.ShowSlider()
	$Chart4.ShowSlider()

func _on_Slider_value_changed(value):
	$Chart1.MoveSlider(value)
	$Chart2.MoveSlider(value)
	$Chart3.MoveSlider(value)
	$Chart4.MoveSlider(value)

func SetupJSON(json):
	max_alt = global.altitude
	var questions = json["Questions"]
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var curQuestion = questions[rng.randi_range(0, questions.size()-1)]
	$QuestionPanel/QuestionText.text = curQuestion["QuestionText"]
	
	var answers = [0, 1, 2, 3]
	var i = 0
	while answers.size() > 0:
		var answerInd = rng.randi_range(0, answers.size() - 1)
		$QuestionPanel.get_child(i).get_child(0).text = curQuestion["Answers"][answers[answerInd]]
		if (answers[answerInd] == 0):
			$QuestionPanel.correctAnswer = i
		answers.remove(answerInd)
		i += 1

func SetupCSV(csv):
	sensorData = csv
	var sensor = csv[0]["Data"]
	for i in sensor.size():
		altitude.append(1 - exp(-5*float(i) / float(sensor.size()) ))
	
	var maxValue = altitude.max()
	for j in range(altitude.size()):
		altitude[j] *= max_alt / maxValue
	
	Start()
