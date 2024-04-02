extends Node2D

func _ready():
	global.SFX(3)
	$TitleText.text = global.local("CONGRATS") + "\n" + global.local("TASK_COMPLETE")
	$GoodbyeText.text = global.finalMessage
	var summary = global.local("ASSEMBLY_TIME") + " " + str(global.assembleTime) + "\n"
	summary += global.local("ASSEMBLY_WRONGS") + " " + str(global.assembleWrongs) + "\n"
	summary += global.local("QUESTION_TRIES") + " " + str(global.questionTries)
	$SummaryText.text = summary
	$MenuButton/BackText.text = global.local("BACK_MENU")

func _on_MenuButton_pressed():
	global.SFX(0)
	get_tree().get_root().get_child(1).NextLevel()
