class_name Bubble

extends Node2D

var ID = 0
@onready var audio : AudioStreamPlayer2D = $Audio
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pop(is_perfect):
	if pressed:
		return
	# play sfx
	# play animation
	# TODO: inform the scroll that this bubble has died. give its ID so it can figure out of there was a pattern
	audio.play()
	kill(true)
	pressed = true
	
	modulate = Color(0,1,0)
	
func kill(was_clicked):
	pass#queue_free()
