extends Node

#This is a script that I have as an autoload in the project settings.
#This needs to be connect to the player script to make the script work.
#You could also call this script in the player script if need be, All
#that would be is var Cmd = get_note(PATH_TO_SCRIPT). I just found it to 
#be easier to make it an autoloader.

var forwardmove : Vector3: get = _get_forwardMove, set = _set_forwardMove
var rightmove : Vector3: get = _get_rightMove, set = _set_rightMove
var upmove : Vector3: get = _get_upMove, set = _set_upMove

func _get_forwardMove():
	return forwardmove

func _set_forwardMove(Newforwardmove):
	forwardmove = Newforwardmove

func _get_rightMove():
	return rightmove

func _set_rightMove(Newrightmove):
	rightmove = Newrightmove

func _get_upMove():
	return upmove

func _set_upMove(Newupmove):
	upmove = Newupmove
