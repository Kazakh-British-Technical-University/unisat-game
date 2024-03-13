extends Node2D

func TryAssembly():
	$DragManager.inactive = true;
	$Sockets.visible = false
	
	RearrangeParts()
	
	var tween = create_tween()
	tween.tween_method(self, "MoveParts", 0.0, 1.0, 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(self, "EndTween")
	
func WinScreen():
	$WinText.visible = true
	$GlowTween.StartGlow()
	
	
func EndTween():
	$Satellite/Assembled.visible = true
	$FinalAssembly.visible = false
	$DragManager.visible = false
	
	var tween = create_tween()
	tween.tween_property($Satellite, "position", Vector2.ONE * 460, 1)
	tween.tween_callback(self, "WinScreen")
	
func RearrangeParts():
	for i in range(9, 0, -1):
			var temp = $Sockets.get_child(i)
			if temp.part_ref != null:
				$DragManager.move_child(temp.part_ref, $DragManager.get_child_count() - 1)
	$DragManager.get_child($DragManager.get_child_count() - 1).z_index = 200

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
	var newPos = lerp(Vector2(166, 272), Vector2(245, 227), part.order / 8.0)
	return lerp(part.plugged_pos, newPos + Vector2(70, 0), t)

func _on_Button_pressed():
	var correct = true
	var wrongs = []
	for i in range(9, 0, -1):
			var temp = $Sockets.get_child(i)
			if temp.part_ref != null:
				if temp.part_name != temp.part_ref.part_name:
					correct = false
					wrongs.append(temp.part_ref)
	
	if correct:
		$AssembleButton.visible = false
		TryAssembly()
	else:
		for i in range(wrongs.size()):
			wrongs[i].modulate = Color.red
		yield(get_tree().create_timer(1),"timeout")
		for i in range(wrongs.size()):
			wrongs[i].modulate = Color.white

func _on_WinButton_pressed():
	get_tree().change_scene("res://Levels/Level2/Level2.tscn")
