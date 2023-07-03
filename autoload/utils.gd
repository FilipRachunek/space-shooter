extends Node


func get_random_vector3_in_range(from, to):
	return Vector3(randf_range(from, to), randf_range(from, to), randf_range(from, to))


func is_valid_node(node):
	return node and is_instance_valid(node)


func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
