class_name Bubble

extends Node2D

var ID = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pop(is_perfect):
	# play sfx
	# play animation
	# TODO: inform the scroll that this bubble has died. give its ID so it can figure out of there was a pattern
	kill(true)
	
func kill(was_clicked):
	queue_free()
