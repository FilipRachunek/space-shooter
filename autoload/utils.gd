extends Node


func get_random_vector3_in_range(from, to):
	return Vector3(randf_range(from, to), randf_range(from, to), randf_range(from, to))


func get_random_x_in_viewport(padding = 0.0):
	return randf_range(GameManager.boundary.left + padding, GameManager.boundary.right - padding)


func is_valid_node(node):
	return node and is_instance_valid(node)


func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array


func get_all_materials_from_scenes(scenes):
	var materials = {}  # dictionary to return only unique materials
	for scene in scenes:
		for material in get_all_materials(scene.instantiate()):
			materials[str(material.get_rid().get_id())] = material
	return materials


func get_all_materials(source_node):
	var materials = []
	for child in get_all_children(source_node):
		if child is MeshInstance3D:
			var mesh: MeshInstance3D = child as MeshInstance3D
			for i in mesh.get_surface_override_material_count():
				# we need only active materials
				var material = mesh.get_active_material(i)
				if material != null and is_instance_valid(material):
					materials.append(material)
		if child is GPUParticles3D:
			var particle: GPUParticles3D = child as GPUParticles3D
			var material = particle.draw_pass_1.surface_get_material(0)
			if material != null and is_instance_valid(material):
				materials.append(material)
		if child is CPUParticles3D:
			var particle: CPUParticles3D = child as CPUParticles3D
			var material = particle.mesh.surface_get_material(0)
			if material != null and is_instance_valid(material):
				materials.append(material)
	return materials
