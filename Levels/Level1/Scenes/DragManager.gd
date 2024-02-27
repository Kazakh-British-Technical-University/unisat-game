extends Node2D

var top_part : Part = null
var offset = Vector2.ZERO
var inactive = false
var inPopup = false
var clickTime = 0.2
var t = 0.0

func _process(delta):
	if inactive or inPopup:
		return
	if Input.is_action_just_pressed("click"):
		$Pointer.global_position = get_global_mouse_position()
		t = 0;
	if Input.is_action_pressed("click"):
		if (top_part != null):
			t += delta
			top_part.global_position = get_global_mouse_position() + offset
			move_child(top_part, get_child_count())
	elif Input.is_action_just_released("click"):
		$Pointer.global_position = Vector2(-100, -100)
		if top_part != null:
			if t <= clickTime:
				$"../Popup".ShowPopup(top_part.part_name)
			top_part.ReturnPart()
			top_part = null

func _on_Pointer_area_entered(area):
	if area.is_in_group("zone") or area.is_in_group("center"):
		return

	if (top_part == null) or (top_part.get_index() < area.get_index()):
		top_part = area
		offset = top_part.global_position - get_global_mouse_position()
