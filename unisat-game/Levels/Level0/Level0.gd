extends Node2D

var curButtonNum = 0
var buttonScene = preload("res://Levels/Level0/ScenarioButton.tscn")
var json : Dictionary
var scenarioId = 0
var diffText = "Easy"
var diffIconsPaths = 	[
						"res://Levels/Level0/Sprites/easy.png",
						"res://Levels/Level0/Sprites/medium.png",
						"res://Levels/Level0/Sprites/hard.png"
						]
var curScreen = 0

func _ready():
	$DescriptionFrame/DescriptionTitle.text = global.local("DESCRIPTION")
	$DescriptionFrame/GoButton/Label.text = global.local("GO")
	$TaskBg/MissionFrame/MissionTitle.text = global.local("MISSION")
	$TaskBg/StartButton/Label.text = global.local("START_MISSION")

func ParseJSON(parsed):
	json = parsed
	for i in range(parsed["Scenarios"].size()):
		CreateScenarioButton(parsed["Scenarios"][i], i)

func CreateScenarioButton(scenario, i):
	var newButton = buttonScene.instance()
	$ScrollContainer/VBoxContainer.add_child(newButton)
	newButton.rect_position = Vector2(280, curButtonNum * 142 + 216)
	newButton.SetButton(scenario["Name"])
	newButton.scenarioId = i
	curButtonNum += 1

func SelectScenario(id):
	scenarioId = id
	curScreen = 1
	$BackButton.visible = true
	
	$ScrollContainer.visible = false
	$DescriptionFrame.visible = true
	
	var diffInd = int(json["Scenarios"][id]["Difficulty"])
	match diffInd:
		0:
			diffText = global.local("EASY")
		1:
			diffText = global.local("MEDIUM")
		2:
			diffText = global.local("HARD")
	
	$DescriptionFrame/Difficulty.texture = load(diffIconsPaths[json["Scenarios"][id]["Difficulty"]])
	$DescriptionFrame/Difficulty/Label.text = diffText
	
	$DescriptionFrame/DescriptionText.text = json["Scenarios"][id]["Description"]
	$DescriptionFrame/PartsText.text = global.local("MISSING_PARTS") + str(json["Scenarios"][id]["NumParts"])
	$DescriptionFrame/AltitudeText.text = global.local("LAUNCH_ALTITUDE") + str(json["Scenarios"][id]["Altitude"])
	$DescriptionFrame/PayloadText.text = global.local("PAYLOAD") + json["Scenarios"][id]["Payload"]
	$DescriptionFrame/QuestionText.text = global.local("DECISION") + diffText

func _on_GoButton_pressed():
	global.SFX(0)
	curScreen = 2
	$DescriptionFrame.visible = false
	$TaskBg.visible = true
	$TaskBg/MissionFrame/MissionText.text = json["Scenarios"][scenarioId]["Mission"]

func _on_StartButton_pressed():
	global.SFX(0)
	global.altitude = json["Scenarios"][scenarioId]["Altitude"]
	get_tree().get_root().get_child(1).StartScenario(scenarioId)

func _on_CloseButton_pressed():
	global.SFX(0)
	match curScreen:
		2:
			$TaskBg.visible = false
			$DescriptionFrame.visible = true
		1:
			$DescriptionFrame.visible = false
			$ScrollContainer.visible = true
			$BackButton.visible = false
	curScreen -= 1


