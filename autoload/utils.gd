extends Node


func get_random_vector3_in_range(from, to):
	return Vector3(randf_range(from, to), randf_range(from, to), randf_range(from, to))


func is_valid_node(node):
	return node and is_instance_valid(node)
