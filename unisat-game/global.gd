extends Node

var externalator_initated = false

func SFX(id):
	get_tree().get_root().get_child(1).SFX(id)

var curLang = 1
var dict : Dictionary
func local(line : String):
	if (dict.has(line)):
		return dict[line][curLang]
	else:
		return "Translation missing"

var altitude = 100
var questionTries = 0
var assembleWrongs = 0
var assembleTime = 0.0
var finalMessage = ""
