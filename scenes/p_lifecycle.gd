class_name PowerUpLifecycle
extends Node


var current_direction
var current_rotation
var mesh_instance
var emission_energy_multiplier = 0.0
var emission_change_direction = 1.0


func init(power_up):
	current_direction = Vector3(0, 0, 2.0)
	current_rotation = Vector3(0, 0, 2.0)
	power_up.scale_object_local(Vector3(4, 4, 4))
	for mesh in power_up.get_children():
		if mesh is MeshInstance3D:
			mesh_instance = mesh
	set_emission(emission_energy_multiplier)


func process(node, delta):
	# check the lifecycle timeline by the elapesd time (since the spawn)
	node.global_translate(current_direction * delta)
	node.rotate_z(current_rotation.z * delta)
	emission_energy_multiplier += emission_change_direction * delta / 2.0
	if emission_energy_multiplier < 0 or emission_energy_multiplier > 0.1:
		emission_change_direction = -emission_change_direction
	set_emission(emission_energy_multiplier)
	# remove power-ups that make it beyond the bottom boundary
	if node.position.z > GameManager.boundary.bottom + GameManager.boundary_margin:
		node.queue_free()


func set_emission(emission):
	mesh_instance.get_active_material(0).emission_energy_multiplier = emission
