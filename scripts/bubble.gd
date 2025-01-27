class_name Bubble

extends Node2D

var ID = 0
@onready var audio : AudioStreamPlayer2D = $Audio
@export var good_clips : Array[AudioStream]
@export var bad_clips : Array[AudioStream]
var pressed = false

@onready var sprite : Sprite2D = $Sprite2D
var sprite_idx = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_idx = randi_range(0,3)

	sprite.texture.set_region(Rect2(128 * sprite_idx, 128, 128, 128))
	var flip = randi_range(0,4)
	if flip == 0 or flip == 2:
		sprite.scale.x *= -1
	if flip == 2 or flip == 3:
		sprite.scale.y *= -1
		
	var r = randf_range(220.0, 255.0) / 255
	var g = randf_range(220.0, 255.0) / 255
	var b = randf_range(220.0, 255.0) / 255
	sprite.modulate = Color(r,g,b)
	
func pop(is_perfect, idx):
	if pressed:
		return
	# play sfx
	# play animation
	# TODO: inform the scroll that this bubble has died. give its ID so it can figure out of there was a pattern
	if is_perfect:
		audio.stream = good_clips[randi() % good_clips.size()]
	else:
		audio.stream = bad_clips[randi() % bad_clips.size()]
		
	sprite.texture.set_region(Rect2(128 * sprite_idx, 0, 128, 128))
	kill(true)
	pressed = true
	
	var sound_delay = float(idx) / 100
	await get_tree().create_timer(sound_delay).timeout
	
	audio.pitch_scale = randi_range(0.7, 1.5)
	audio.play()
	

	
func kill(was_clicked):
	pass#queue_free()
