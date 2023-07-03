extends Area3D


@onready var bullet_trail = $Trail

var current_direction
@export var hit_points = 10.0
@export var speed = 150.0


func init(weapon):
	position = weapon.global_position
	position.y = 0
	# a weapon always has just one child node to set direction
	var direction_node = weapon.get_children()[0]
	current_direction = direction_node.position
	# get the bullet orientation and rotate on the Y axis
	var direction_angle = Vector2(current_direction.x, current_direction.z).angle_to(Vector2.UP)
	rotate_y(direction_angle)


func _process(delta):
	bullet_trail.add_new_point(GameManager.to_2D(global_position))
	translate(Vector3(0, 0, -delta * speed))
	# if FPS is low, a bullet can skip the boundary, so we better check
	if !GameManager.is_in_boundary(self):
		queue_free()
