extends Node2D

@export var follow_speed = 10
@export var click_radius = 24
var bonus_radius = 0
var max_combo = 4
@export var line_point_ct = 16
@export var line : Line2D

var combo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousepos = get_local_mouse_position()
	draw_hit_preview()

func get_radius():
	return click_radius + bonus_radius * combo / max_combo

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var space = get_world_2d().direct_space_state
		var pos = get_canvas_transform().affine_inverse() * event.position
		
		var query = PhysicsShapeQueryParameters2D.new()
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.transform  = Transform2D(0, pos)
		var circle = CircleShape2D.new()
		circle.radius = get_radius()
		query.shape_rid = circle.get_rid()
	
		var hit_ct = 0
		var perfect_hit_ct = 0
		var hits = space.intersect_shape(query)
		for hit in hits:
			if hit.collider is Bubble:
				var hit_dir = hit.collider.global_position - pos
				var len = hit_dir.length()
				var perfect_hit = len <  get_radius()
				(hit.collider as Bubble).pop(perfect_hit)
				if perfect_hit:
					perfect_hit_ct += 1
				hit_ct += 1
			
			
			# STRETCH: popping a cute pattern in the bubbles will yield a power up
			# pattern ideas: Tetris piece, cross, H -> I, 
			# patterns (16): smiley
		if float(perfect_hit_ct) / hit_ct > 0.5:
			combo += 1
			if combo >= max_combo:
				bonus_radius = 38
				# TODO: play cool sfx to indicate combo
		else:
			combo = 0
			
func draw_hit_preview():
	# clear points
	line.clear_points()
	var points = []
	var mouse_pos = get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()

	for i in line_point_ct:
		var angle = 2 * PI * (float(i)/line_point_ct)
		var x = cos(angle) * get_radius()
		var y = sin(angle) * get_radius()

		line.add_point(Vector2(x,y) + mouse_pos)

		
	

