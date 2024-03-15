class_name Part extends Area2D

var body_ref
var initPos : Vector2
var initAngle = 0
var plugged_pos : Vector2
var order = 0
export var preplaced = true

export var part_name = "antenna"

func _ready():
	initPos = global_position
	initAngle = rotation

func ReturnPart():
	var finalPos = initPos
	
	if body_ref != null:
		finalPos = body_ref.global_position
	
	get_parent().inactive = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", finalPos, 0.2).set_ease(Tween.EASE_OUT)
	tween.tween_callback(self, "DragDone")

func DragDone():
	$CollisionShape2D.scale = Vector2.ONE * 0.6
	plugged_pos = global_position
	get_parent().inactive = false
	if (body_ref != null):
		body_ref.occupy(true, self)
		order = 10 - body_ref.order
		
		for i in range(9, 0, -1):
			print("i = " + str(i))
			var temp = $"../../Sockets".get_child(i)
			if temp.part_ref != null:
				get_parent().move_child(temp.part_ref, get_parent().get_child_count())
				print(temp.part_ref)
	
	$"../../AssembleButton".visible = $"../../Sockets".NumFree() == 0

func _on_Part_area_entered(area):
	if area.is_in_group("zone"):
		rotation = 0
		$PlugOut.visible = false
		$PlugIn.visible = true

func _on_Part_area_exited(area):
	if area.is_in_group("zone"):
		$CollisionShape2D.scale = Vector2.ONE
		rotation = initAngle
		$PlugOut.visible = true
		$PlugIn.visible = false

func _on_Inner_Area_body_entered(body):
	if body.is_in_group('sockets') and not body.Full():
		if body_ref != null:
			body_ref.occupy(false, null)
		body.Grow(true)
		body_ref = body

func _on_Inner_Area_body_exited(body):
	if body.is_in_group('sockets'):
		if body == body_ref:
			body.occupy(false, null)
			body_ref = null
		body.Grow(false)

func PreplacePart(body):
	rotation = 0
	$PlugOut.visible = false
	$PlugIn.visible = true
	
	body_ref = body
	body_ref.occupy(true, self)
	order = 10 - body_ref.order
	
	$CollisionShape2D.scale = Vector2.ONE * 0.6
	global_position = body_ref.global_position
	plugged_pos = global_position
