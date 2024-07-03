class_name Lifecycle
extends Node


var spawn = {}
var timeline = []
var elapsed_time = 0.0
var previous_second = 0.0
var current_direction
var current_rotation
var target
var speed
var max_hit_points = 0.0
var hit_points = 0.0
var max_shield_power = 1.0  # so we don't divide by zero accidentally
var shield_power = 0.0


signal enemy_spawned(source_node)
signal enemy_destroyed(source_node)
signal bullet_hit(enemy, bullet)
signal weapon_fired(enemy, event)


func init(root_node, enemy, _spawn, _timeline):
	spawn = _spawn
	timeline = _timeline
	hit_points = spawn.hit_points
	max_hit_points = hit_points
	if spawn.has("shield_power"):
		shield_power = spawn.shield_power
		max_shield_power = shield_power
	if spawn.has("power_up"):
		enemy.power_up = spawn.power_up
	enemy.translate(spawn.coords)
	enemy.scale_object_local(spawn.scale)
	current_direction = spawn.direction
	speed = current_direction.length()
	current_rotation = spawn.rotation
	if spawn.has("target"):
		target = spawn.target
	enemy_spawned.connect(Callable(root_node, "_on_enemy_spawned"))
	enemy_destroyed.connect(Callable(root_node, "_on_enemy_destroyed"))
	bullet_hit.connect(Callable(root_node, "_on_show_hit_effect"))
	weapon_fired.connect(Callable(root_node, "_on_weapon_fired"))


func process(enemy, delta):
	if elapsed_time == 0.0:
		enemy_spawned.emit(enemy)
	# check the lifecycle timeline by the elapsed time (since the spawn)
	elapsed_time += delta
	if elapsed_time - previous_second > 1.0:
		previous_second += 1
		for event in timeline:
			if event.timestamp <= elapsed_time && !event.has("processed"):
				process_event(enemy, event)
				event.processed = true
	if Utils.is_valid_node(target):
		var to_target = target.global_position - enemy.global_position
		current_direction = to_target.normalized() * speed
		var direction_angle = Vector2(to_target.x, to_target.z).angle_to(Vector2.UP)
		enemy.rotation.y = direction_angle
		enemy.global_position = enemy.global_position.move_toward(target.global_position, delta * speed)
	else:
		enemy.global_position.x += current_direction.x * delta
		enemy.global_position.z += current_direction.z * delta
	if current_rotation != Vector3.ZERO:
		enemy.rotate_x(current_rotation.x * delta)
		enemy.rotate_y(current_rotation.y * delta)
		enemy.rotate_z(current_rotation.z * delta)
	# remove enemies that make it beyond the boundary and after some time (certain objects spawn above the top barrier)
	if elapsed_time > 5 and not GameManager.is_in_boundary(enemy):
		enemy.queue_free()


func process_event(enemy, event):
	if event.has("fire"):
		if event.fire.has("weapon") and GameManager.is_in_boundary(enemy):
			weapon_fired.emit(enemy, event)


func process_hit(enemy, area):
	var value = area.hit_points
	if shield_power > 0:
		shield_power -= value
		if shield_power <= 0:
			value = -shield_power
	if shield_power <= 0:
		hit_points -= value
	# show a small fire at the impact point
	bullet_hit.emit(enemy, area)
	if hit_points <= 0:
		explode(enemy)


func explode(enemy):
	# send signal to the main script
	enemy_destroyed.emit(enemy)


func get_hull_integrity():
	return hit_points * 100 / max_hit_points


func get_shield_power():
	return shield_power * 100 / max_shield_power
