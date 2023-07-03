class_name Lifecycle
extends Node


var spawn = {}
var elapsed_time = 0.0
var current_direction
var current_rotation
var speed
var max_hit_points = 0.0
var hit_points = 0.0


signal enemy_destroyed(source_node)
signal bullet_hit(enemy, bullet)


func init(root_node, enemy, _spawn):
	spawn = _spawn
	hit_points = spawn.hit_points
	max_hit_points = hit_points
	enemy.translate(spawn.coords)
	enemy.scale_object_local(spawn.scale)
	current_direction = spawn.direction
	speed = current_direction.length()
	current_rotation = spawn.rotation
	connect("enemy_destroyed", Callable(root_node, "_on_enemy_destroyed"))
	connect("bullet_hit", Callable(root_node, "_on_show_hit_effect"))


func process(enemy, delta):
	elapsed_time += delta
	enemy.global_position.x += current_direction.x * delta
	enemy.global_position.z += current_direction.z * delta
	if current_rotation != Vector3.ZERO:
		enemy.rotate_x(current_rotation.x * delta)
		enemy.rotate_y(current_rotation.y * delta)
		enemy.rotate_z(current_rotation.z * delta)
	# remove enemies that make it beyond the boundary and after some time (certain objects spawn above the top barrier)
	if elapsed_time > 5 and not GameManager.is_in_boundary(enemy):
		enemy.queue_free()


func process_hit(enemy, area):
	hit_points -= area.hit_points
	bullet_hit.emit(enemy, area)
	if hit_points <= 0:
		explode(enemy)


func explode(enemy):
	# send signal to the main script
	enemy_destroyed.emit(enemy)
