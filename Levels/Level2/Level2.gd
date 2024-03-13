extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(2),"timeout")
	var tween = create_tween()
	tween.tween_method(self, "Fade", 0.0, 1.0, 1)
	tween.tween_callback(self, "End")

func Fade(t):
	$Popup.modulate.a = t

func End():
	get_tree().change_scene("res://Levels/Level3/Scenes/Level3.tscn")
