extends Node2D

func _ready():
	$Launch/Button/Label.text = global.local("LAUNCH_SAT")

func End():
	get_tree().get_root().get_child(1).NextLevel()

var first = true
func _on_VideoPlayer_finished():
	if first:
		$VideoPlayer.visible = false
		$Launch.visible = true
	else:
		End()

func _on_Button_pressed():
	first = false
	$Launch.visible = false
	$VideoPlayer.visible = true
	$VideoPlayer.stream = load("res://Levels/Level2/920х920_part2.ogv")
	$VideoPlayer.play()
