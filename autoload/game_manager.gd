extends Node


@onready var small_star_scene = preload("res://scenes/small_star.tscn")
@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var explosion_scene = preload("res://scenes/explosion.tscn")
@onready var hit_effect_scene = preload("res://scenes/hit_effect.tscn")

var player

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


func set_player(_player):
	player = _player


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


func spawn_asteroids(root_node):
	for i in 5:
		var spawn = {
			"hit_points": 20,
			"coords": Vector3(-40 + i * 20, 0, -30),
			"scale": Utils.get_random_vector3_in_range(1, 4),
			"direction": Vector3(0, 0, randf_range(5.0, 15.0)),
			"rotation": Utils.get_random_vector3_in_range(0.1, 1.0),
		}
		var asteroid = asteroid_scene.instantiate()
		asteroid.init(root_node, spawn)
		root_node.add_child(asteroid)


func fire_player_weapon(root_node):
	for weapon in player.weapons:
		if weapon.active:
			var bullet = bullet_scene.instantiate()
			bullet.init(weapon)
			root_node.add_child(bullet)
	SoundManager.fire_bullet()


func create_explosion(root_node, source_node, width, height):
	var explosion = explosion_scene.instantiate()
	var speed = 1.0
	explosion.init(source_node.global_transform.origin.x, source_node.global_transform.origin.z, width, height, speed)
	root_node.add_child(explosion)
	source_node.queue_free()


func create_hit_effect(root_node, enemy, bullet):
	var hit_effect = hit_effect_scene.instantiate()
	hit_effect.init(bullet.position.x, bullet.position.z)
	root_node.add_child(hit_effect)
	if enemy.is_in_group("metal"):
		SoundManager.metal_hit_effect()
	else:
		SoundManager.rock_hit_effect()
