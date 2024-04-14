extends Button

var scenarioId = 0

func SetButton(_text):
	$Label.text = global.local(_text)

func _on_Button_pressed():
	global.SFX(0)
	get_parent().get_parent().get_parent().SelectScenario(scenarioId)
	#get_tree().get_root().get_child(1).StartScenario(scenarioId)
