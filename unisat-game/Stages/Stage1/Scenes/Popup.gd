extends Node2D

func ShowPopup(title, part_ref):
	$"../DragManager".inPopup = true
	
	$Window.visible = true
	$Window/PicHolder/Pic.texture = part_ref.GetTexture()
	$Window/PicHolder/Pic.position = part_ref.GetOffset()
	
	#$Window/Title.text = title
	$Window/Title.text = global.local(title+"1")
	$Window/TextTop.text = global.local(title+"2")
	$Window/TextTop2.text = global.local(title+"3")

func _on_CloseButton_pressed():
	$Window.visible = false
	$"../DragManager".inPopup = false
