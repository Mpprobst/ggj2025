class_name Scroller

extends Node2D

@export var scroll_area : Sprite2D
@export var speed = 100;

@export var bubbles_parent : Node2D
@export var bubble_norm : PackedScene

@export var background_image : PackedScene

var bubbles = []
var backgrounds = []

var spawn_height = -512
var cull_height = 1024
var area_width = 512

var row_size = 4
var element_size = Vector2(128, 128)

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	cull_height = scroll_area.texture.get_height() * 1.5
	spawn_bubbles()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0, delta * speed);
	
	if bubbles.size() > 0:
		var y = (bubbles[bubbles.size()-1].global_position + spawn_delta()).y

		if y > spawn_height:
			spawn_bubbles()
		y = bubbles[0].global_position.y

		if y >= cull_height:
			clear_bubbles()
	
	# when background height hits areaheight, spawn a new one
	var last_background = null
	if backgrounds.size() > 0:
		last_background = backgrounds[backgrounds.size()-1]
	if last_background == null:
		last_background = spawn_background(Vector2(0,0))
		
	if last_background.global_position.y >= 512:
		spawn_background(last_background.global_position)
	
	#if backgrounds.size() > 0:
	#	var first_background = backgrounds[0]
	#	if first_background.global_position.y >= cull_height * 2:
	#		backgrounds[0].queue_free()
	#		backgrounds.remove_at(0)
		
		
	# TODO: when position is low enough, spawn more sheets
	# need a list of prefabs to choose from
	# the mouse_controller can trigger certain events: speed boost, different pattern, dance party
	
func spawn_delta():
	var delta = Vector2(0,0)
	var column = bubbles.size() % row_size
	if column == 0:
		delta = Vector2((-row_size / 2 - 1)* element_size.x, -element_size.y)
	else:
		delta = Vector2(element_size.x, 0)
	return delta

func spawn_bubbles():
	var last_pos = Vector2(-(row_size / 2 - 0.5) * element_size.x, -element_size.y / 2) #initialized with the position of the very first bubble			
	if bubbles.size() > 0:
		last_pos = bubbles[bubbles.size()-1].global_position + spawn_delta()
	
	while spawn_height < last_pos.y && last_pos.y < cull_height:
		var bubble = spawn_bubble_single(last_pos)
		bubbles.append(bubble)
		last_pos += spawn_delta()

func spawn_bubble_single(spawn_pos):
	var bubble : Bubble = bubble_norm.instantiate()
	bubbles_parent.add_child(bubble)
	bubble.global_position = spawn_pos
	return bubble

func clear_bubbles():
	var bub = bubbles[0]
	while bub.global_position.y >= cull_height:
		bub.queue_free()
		bubbles.remove_at(0)
		bub = bubbles[0]
	
	# move my position back to 0,0 and move everything by that diff
	var diff = position
	position = Vector2(0,0)
	
	for bubble in bubbles:
		bubble.global_position += diff
	
	if backgrounds[0].global_position.y >= cull_height *2:
		backgrounds[0].queue_free()
		backgrounds.remove_at(0)
	
	diff.y -= element_size.y
	for background in backgrounds:
		background.global_position += diff
		
	# TODO: maintain an array of backgrounds and delete similarly as above
	
func spawn_background(pos):
	if pos != Vector2(0,0):
		pos += Vector2(0, -512)
	
	var last_background = background_image.instantiate()
	backgrounds.append(last_background)
	add_child(last_background)
	move_child(last_background, 0)
	last_background.global_position = pos
	
	return last_background
