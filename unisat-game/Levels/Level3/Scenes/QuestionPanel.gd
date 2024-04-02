extends Sprite

var correctAnswer = 0
var active = true
var pressedButtons = []
func _on_A_pressed():
	if (pressedButtons.has($A)):
		return
	global.questionTries += 1
	if active:
		if (correctAnswer == 0):
			$A.modulate = Color.green
			EndGame()
		else:
			global.SFX(2)
			$A.modulate = Color.red
	
	pressedButtons.append($A)

func _on_B_pressed():
	if (pressedButtons.has($B)):
		return
	global.questionTries += 1
	if active:
		if (correctAnswer == 1):
			$B.modulate = Color.green
			EndGame()
		else:
			global.SFX(2)
			$B.modulate = Color.red
	
	pressedButtons.append($B)

func _on_C_pressed():
	if (pressedButtons.has($C)):
		return
	global.questionTries += 1
	if active:
		if (correctAnswer == 2):
			$C.modulate = Color.green
			EndGame()
		else:
			global.SFX(2)
			$C.modulate = Color.red
		
	pressedButtons.append($C)

func _on_D_pressed():
	if (pressedButtons.has($D)):
		return
	global.questionTries += 1
	if active:
		if (correctAnswer == 3):
			$D.modulate = Color.green
			EndGame()
		else:
			global.SFX(2)
			$D.modulate = Color.red
	
	pressedButtons.append($D)

func EndGame():
	active = false
	global.SFX(3)
	yield(get_tree().create_timer(2),"timeout")
	get_tree().get_root().get_child(1).NextLevel()
