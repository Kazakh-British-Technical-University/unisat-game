extends StaticBody2D

var part_name = "none"

var order = 0

var part_ref : Part = null

func occupy(hide, new_part):
	$Sprite.visible = not hide
	part_ref = new_part

func Grow(big):
	if big:
		$Sprite.scale = Vector2.ONE * 0.7
	else:
		$Sprite.scale = Vector2.ONE * 0.5

func Full():
	return not $Sprite.visible
