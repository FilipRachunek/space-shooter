extends Node


@onready var small_star_scene = preload("res://scenes/small_star.tscn")

var boundary = {
	"left": 0.0,
	"right": 0.0,
	"top": 0.0,
	"bottom": 0.0,
}
var boundary_margin = 10.0


func set_boundary(left, right, top, bottom):
	boundary.left = left
	boundary.right = right
	boundary.top = top
	boundary.bottom = bottom


func is_in_boundary(node, add_margin = true):
	var margin = boundary_margin if add_margin else 0.0
	return (node.global_position.x > boundary.left - margin
		and node.global_position.x < boundary.right + margin
		and node.global_position.z > boundary.top - margin
		and node.global_position.z < boundary.bottom + margin)


func spawn_stars(root_node):
	for i in 40:
		spawn_star(root_node, false)


func spawn_star(root_node, on_top):
	var star = small_star_scene.instantiate()
	star.init(
		randf_range(boundary.left, boundary.right),
		randf_range(-20.0, -50.0),
		boundary.top - boundary_margin if on_top else randf_range(boundary.top, boundary.bottom),
		randf_range(0.02, 0.2)
	)
	root_node.add_child(star)


func process_background(root_node, delta):
	for small_star in get_tree().get_nodes_in_group("small_star"):
		small_star.global_position.z += small_star.vertical_speed * delta
		var z = small_star.position.z
		if z > boundary.bottom + boundary_margin:
			small_star.queue_free()
			# spawn a new star at the screen top
			spawn_star(root_node, true)
