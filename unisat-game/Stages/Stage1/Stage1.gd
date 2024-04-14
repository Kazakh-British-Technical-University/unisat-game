extends Node2D

var startTime
var partPrefab = preload("res://Stages/Stage1/Scenes/Part.tscn")
func Start(json):
	#SpawnParts(json)
	for obj in json["PreplacedParts"]:
		if obj["Preplaced"]:
			var part : Part = $DragManager.find_node(obj["PartName"]) as Part
			
			for j in range(1, $Sockets.get_child_count()-1):
				var sock = $Sockets.get_child(j)
				if part.part_name == sock.part_name and not sock.Full():
					part.PreplacePart($Sockets.get_child(j))
					break
	RearrangeParts()

func _ready():
	startTime = Time.get_ticks_msec()
	$AssembleButton/Label.text = global.local("ASSEMBLE")
	$WinText/Button/Label.text = global.local("LAUNCH")
	$WinText.text = global.local("CONGRATS")

func SpawnParts(json):
	for obj in json["Parts"]:
		#var part : Part = $DragManager.find_node(obj["PartName"]) as Part
		var part = partPrefab.instance()
		print(obj["PartFile"])
		

func _on_Button_pressed():
	var correct = true
	var wrongs = []
	for i in range(8, 0, -1):
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
	for i in range(8, 0, -1):
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
