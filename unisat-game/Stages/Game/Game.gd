extends Node2D

var curJSON : Dictionary
var sensorData = []

var curScene : Node
var curScenario = 0
var curLevel = 0

var level0 = preload("res://Stages/Stage0/Stage0.tscn")
var level1 = preload("res://Stages/Stage1/Stage1.tscn")
var level2 = preload("res://Stages/Stage2/Stage2.tscn")
var level3 = preload("res://Stages/Stage3/Scenes/Stage3.tscn")
var level4 = preload("res://Stages/Stage4/Stage4.tscn")

func _ready():
	_on_SoundButton_pressed()
	$JSONparser.LoadTranslations()
	yield(get_tree().create_timer(0.3),"timeout")
	LoadJSON()

func SetCSV(_sensorData):
	sensorData = _sensorData

func LoadJSON():
	match curLevel:
		0:
			$JSONparser.LoadJSON(langs[global.curLang] + "_ScenarioList.json")
		1:
			$JSONparser.LoadJSON(langs[global.curLang] + "_Scenario" + str(curScenario) + ".json")

func Result(json):
	curJSON = json
	
	match curLevel:
		0:
			curScene = level0.instance()
			$LevelContainer.add_child(curScene)
			curScene.ParseJSON(curJSON)
		1:
			curScene.queue_free()
			curScene = level1.instance()
			$LevelContainer.add_child(curScene)
			curScene.Start(curJSON["Assembly"])
		2:
			$JSONparser.LoadCSV(curJSON["DataPath"])
			curScene.queue_free()
			curScene = level2.instance()
			$LevelContainer.add_child(curScene)
		3:
			curScene.queue_free()
			curScene = level3.instance()
			$LevelContainer.add_child(curScene)
			curScene.SetupJSON(curJSON["DataCollection"])
			curScene.SetupCSV(sensorData)
		4:
			global.finalMessage = curJSON["FinalMessage"]
			curScene.queue_free()
			curScene = level4.instance()
			$LevelContainer.add_child(curScene)

func StartScenario(id):
	curScenario = id
	curLevel = 1
	LoadJSON()

func NextLevel():
	curLevel += 1
	if (curLevel > 4):
		curScene.queue_free()
		curLevel = 0
		global.assembleTime = 0
		global.assembleWrongs = 0
		global.questionTries = 0
		LoadJSON()
	else:
		Result(curJSON)

var soundOn = true
func _on_SoundButton_pressed():
	soundOn = not soundOn
	if soundOn:
		$SoundButton.icon = load("res://Stages/Game/Sprites/sound_on.png")
		$Music.volume_db = 0
		$sfx1.volume_db = 0
		$sfx2.volume_db = 0
		$sfx3.volume_db = 0
		$sfx4.volume_db = 0
	else:
		$SoundButton.icon = load("res://Stages/Game/Sprites/sound_off.png")
		$Music.volume_db = -80
		$sfx1.volume_db = -80
		$sfx2.volume_db = -80
		$sfx3.volume_db = -80
		$sfx4.volume_db = -80

func SFX(id):
	match id:
		0:
			$sfx1.play()
		1:
			$sfx2.play()
		2:
			$sfx3.play()
		3:
			$sfx4.play()

var langs = ["EN", "RU", "KZ"]
func _on_LanguageButton_pressed():
	global.curLang += 1
	if (global.curLang == 3):
		global.curLang = 0
	$LanguageButton/Label.text = langs[global.curLang]
