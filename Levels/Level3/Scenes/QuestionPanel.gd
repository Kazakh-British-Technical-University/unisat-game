extends ColorRect

var correctAnswer = 0
var active = true
func _on_A_pressed():
	if active:
		if (correctAnswer == 0):
			$A.modulate = Color.green
		else:
			$A.modulate = Color.red
		
		EndGame(correctAnswer == 0)


func _on_B_pressed():
	if active:
		if (correctAnswer == 1):
			$B.modulate = Color.green
		else:
			$B.modulate = Color.red
			
		EndGame(correctAnswer == 1)


func _on_C_pressed():
	if active:
		if (correctAnswer == 2):
			$C.modulate = Color.green
		else:
			$C.modulate = Color.red
		
		EndGame(correctAnswer == 2)

func _on_D_pressed():
	if active:
		if (correctAnswer == 3):
			$D.modulate = Color.green
		else:
			$D.modulate = Color.red
		
		EndGame(correctAnswer == 3)
	
func EndGame(success):
	active = false
	$Congrats.visible = true
	if success:
		global.SFX(3)
		$Congrats/CongratsText.text = "Good job!"
	else:
		global.SFX(2)
		$Congrats/CongratsText.text = "Try again..."

func _on_EndGameButton_pressed():
	global.SFX(0)
	get_tree().get_root().get_child(1).NextLevel()
