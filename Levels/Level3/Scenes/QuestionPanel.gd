extends ColorRect

var active = true
func _on_A_pressed():
	if active:
		$A.modulate = Color.aquamarine
		EndGame()


func _on_B_pressed():
	if active:
		$B.modulate = Color.aquamarine
		EndGame()


func _on_C_pressed():
	if active:
		$C.modulate = Color.aquamarine
		EndGame()

func _on_D_pressed():
	if active:
		$D.modulate = Color.aquamarine
		EndGame()
	
func EndGame():
	active = false
	$Congrats.visible = true


func _on_EndGameButton_pressed():
	get_tree().change_scene("res://Levels/Level1/Level1.tscn")
