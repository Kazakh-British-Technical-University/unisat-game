extends Node

var externalator_initated = false

func SFX(id):
	get_tree().get_root().get_child(1).SFX(id)

var curLang = 0
var dict : Dictionary
func local(line : String):
	if (dict.has(line)):
		return dict[line][curLang]
	else:
		return "Translation missing"
