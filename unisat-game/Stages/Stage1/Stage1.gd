extends Node2D

var startTime
var partPrefab = preload("res://Stages/Stage1/Scenes/Part.tscn")
var partsJson : Dictionary

func Start(json):
	partsJson = json
	partNum = json["Parts"].size()
	for i in range(partNum):
		positions.push_back(i)
	LoadNextPart()

func _ready():
	startTime = Time.get_ticks_msec()
	$AssembleButton/Label.text = global.local("ASSEMBLE")
	$WinText/Button/Label.text = global.local("LAUNCH")
	$WinText.text = global.local("CONGRATS")


var partNum = 0
var loadedParts = 0
func LoadNextPart():
	if (loadedParts < partNum):
		global.LoadJson(partsJson["Parts"][loadedParts]["PartFile"], self)
	else:
		$Sockets.SetupSockets($DragManager)
		PreplaceParts()

var rng = RandomNumberGenerator.new()
var positions = []
func JsonResult(json):
	var curPart : Part
	curPart = partPrefab.instance() as Part
	curPart.part_name = str(json["PartName"])
	curPart.name = "Part " + str(loadedParts)
	$DragManager.add_child(curPart)
	curPart.preplaced = partsJson["Parts"][loadedParts]["Preplaced"]
	curPart.LoadIcons(json)
	var randInd = rng.randi_range(0, positions.size()-1)
	curPart.position = Vector2(100 + positions[randInd] * 720 / (partNum - 1), 600 + rng.randf_range(-150, 150))
	curPart.rotation_degrees = rng.randf_range(0, 360)
	positions.remove(randInd)
	curPart._ready()
	loadedParts += 1

func PreplaceParts():
	for i in range(1, $DragManager.get_child_count()):
		if $DragManager.get_child(i).preplaced:
			for j in range(1, $Sockets.get_child_count()):
					var sock = $Sockets.get_child(j)
					if $DragManager.get_child(i).part_name == sock.part_name and not sock.Full():
						$DragManager.get_child(i).PreplacePart($Sockets.get_child(j))
						break
	RearrangeParts()

func _on_Button_pressed():
	var correct = true
	var wrongs = []
	for i in range(partNum, 0, -1):
			var temp = $Sockets.get_child(i)
			if temp.part_ref != null:
				if temp.part_name != temp.part_ref.part_name:
					correct = false
					wrongs.append(temp.part_ref)
	
	if correct:
		global.SFX(0)
		global.assembleTime = round((Time.get_ticks_msec() - startTime) / 1000)
		$AssembleButton.visible = false
		TryAssembly()
	else:
		global.assembleWrongs += 1
		global.SFX(2)
		for i in range(wrongs.size()):
			wrongs[i].modulate = Color.red
		yield(get_tree().create_timer(1),"timeout")
		for i in range(wrongs.size()):
			wrongs[i].modulate = Color.white

func TryAssembly():
	$DragManager.inactive = true;
	$Sockets.visible = false
	
	RearrangeParts()
	
	var tween = create_tween()
	tween.tween_method(self, "MoveParts", 0.0, 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(self, "EndTween")

func RearrangeParts():
	for i in range(partNum, 0, -1):
			var temp = $Sockets.get_child(i)
			if temp.part_ref != null:
				$DragManager.move_child(temp.part_ref, $DragManager.get_child_count() - 1)
	#$DragManager.get_child($DragManager.get_child_count() - 1).z_index = 200

func MoveParts(t : float):
	for i in range(1, $DragManager.get_child_count()):
		var temp : Part = $DragManager.get_child(i) as Part
		temp.position = GetPos(t, temp)
	
	$FinalAssembly/SolarBotIso.position = lerp(Vector2(204, 321), Vector2(204, 290), t)
	$FinalAssembly/SolarFrontIso.position = lerp(Vector2(294, 290), Vector2(242, 269), t)
	$FinalAssembly/SolarBack1Iso.position = lerp(Vector2(118, 187), Vector2(165, 223), t)
	$FinalAssembly/Frame1Iso2.position = lerp(Vector2(204, 94), Vector2(204, 205), t)
	$FinalAssembly/SolarTopIso.position = lerp(Vector2(204, 60), Vector2(204, 201), t)

func GetPos(t, part : Part):
	var newPos = lerp(Vector2(166, 272), Vector2(245, 227), part.order / 7.0)
	return lerp(part.plugged_pos, newPos + Vector2(70, 0), t)

func EndTween():
	$Satellite/Assembled.visible = true
	$FinalAssembly.visible = false
	$DragManager.visible = false
	
	var tween = create_tween()
	tween.tween_property($Satellite, "position", Vector2.ONE * 460, 1)
	tween.tween_callback(self, "WinScreen")

func WinScreen():
	global.SFX(3)
	$WinText.visible = true
	$GlowTween.StartGlow()

func _on_WinButton_pressed():
	global.SFX(0)
	get_tree().get_root().get_child(1).NextLevel()
