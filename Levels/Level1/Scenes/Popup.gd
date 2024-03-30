extends Node2D

var spriteFolder = "res://Levels/Level1/Sprites/Parts/"

func ShowPopup(title):
	$"../DragManager".inPopup = true
	$Window.visible = true
	$Window/Pic.texture = load(spriteFolder + title + ".png")
	
	#$Window/Title.text = title
	$Window/Title.text = global.local(title+"1")
	$Window/TextTop.text = global.local(title+"2")
	$Window/TextTop2.text = global.local(title+"3")

func _on_CloseButton_pressed():
	$Window.visible = false
	$"../DragManager".inPopup = false
