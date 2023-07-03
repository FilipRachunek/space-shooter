extends Node3D


@onready var fire_mesh : MeshInstance3D = $fire

var fire_width
var fire_height
var fire_speed
var fire_aperture = 0


func _ready():
	fire_mesh.mesh.size = Vector2(fire_width, fire_height)


func init(x, z, width, height, speed = 1.0):
	translate(Vector3(x, 0, z))
	fire_width = width
	fire_height = height
	fire_speed = speed


func _process(delta):
	if (fire_aperture < 1.0):
		fire_aperture += delta * fire_speed
		fire_mesh.set_instance_shader_parameter("fire_aperture", fire_aperture)
	else:
		queue_free()
