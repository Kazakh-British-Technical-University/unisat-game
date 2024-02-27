extends Node2D

var spriteFolder = "res://Levels/Level1/Sprites/Parts/"

func ShowPopup(title):
	$"../DragManager".inPopup = true
	$Window.visible = true
	$Window/Title.text = title
	$Window/Pic.texture = load(spriteFolder + title + ".png")

func _on_CloseButton_pressed():
	$Window.visible = false
	$"../DragManager".inPopup = false
