extends Node2D

@export var follow_speed = 10
@export var click_radius = 24
@export var line_point_ct = 16
@export var line : Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mousepos = get_local_mouse_position()
	draw_hit_preview()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var space = get_world_2d().direct_space_state
		var pos = get_canvas_transform().affine_inverse() * event.position
		
		var query = PhysicsShapeQueryParameters2D.new()
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.transform  = Transform2D(0, pos)
		var circle = CircleShape2D.new()
		circle.radius = click_radius
		query.shape_rid = circle.get_rid()
	
		var hits = space.intersect_shape(query)
		
		print("click at ", pos)	
		for hit in hits:
			print(hit)
			
func draw_hit_preview():
	# clear points
	line.clear_points()
	var points = []
	var mouse_pos = get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()

	for i in line_point_ct:
		var angle = 2 * PI * (float(i)/line_point_ct)
		var x = cos(angle) * click_radius 
		var y = sin(angle) * click_radius

		line.add_point(Vector2(x,y) + mouse_pos)

		
	

