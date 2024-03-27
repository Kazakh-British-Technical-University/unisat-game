extends Node2D

var scenarioListPath = "res://Data/ScenarioList.json"
var curButtonNum = 0
var buttonScene = preload("res://Levels/Level0/ScenarioButton.tscn")
var json : Dictionary
var scenarioId = 0
var diffIconsPaths = 	[
						"res://Levels/Game/Sprites/easy.png",
						"res://Levels/Game/Sprites/normal.png",
						"res://Levels/Game/Sprites/hard.png"
						]

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
	$ScrollContainer.visible = false
	$Details.visible = true
	$TitleText.text = json["Scenarios"][id]["Name"]
	$Details/DescriptionText.text = json["Scenarios"][id]["Description"]
	$Details/Difficulty.texture = load(diffIconsPaths[json["Scenarios"][id]["Difficulty"]])

func _on_StartButton_pressed():
	global.SFX(0)
	get_tree().get_root().get_child(1).StartScenario(scenarioId)

func _on_CloseButton_pressed():
	global.SFX(0)
	$ScrollContainer.visible = true
	$Details.visible = false
