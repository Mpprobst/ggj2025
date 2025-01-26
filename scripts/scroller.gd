extends Node2D

@export var scroll_area : Sprite2D
@export var bubbles_parent : Node2D
@export var bubble_norm : PackedScene
@export var background_image : PackedScene
var speed = 100;

var bubbles = []

var spawn_height = -512
var cull_height = 1024
var area_width = 512

var row_size = 4
var element_size = Vector2(128, 128)

var last_background : Node2D

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
	
	# when background height hits areaheight, spawn a new one
	if last_background == null or last_background.global_position.y >= 512:
		last_background = background_image.instantiate()
		add_child(last_background)
		move_child(last_background, 0)
		last_background.global_position = Vector2(0, 0)

	
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

