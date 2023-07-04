extends CharacterBody3D


const SPEED = 30.0
const FAST_SPEED = 80.0
const MAX_TILT = 0.7
const MIN_SHIELD_ALPHA = 0.01
const MAX_SHIELD_ALPHA = 0.1
const MIN_EMISSION = 0.0
const MAX_EMISSION = 0.5


@onready var weapons_node = $Weapons
@onready var shield = $Shield/Sphere
@onready var shield_collision = $Shield/CollisionShape3D
@onready var body_mesh = $Body

var weapons = []
var tilt = 0.0
var tilt_direction = 0.0
var max_hull_integrity = 100.0
var hull_integrity = max_hull_integrity
var max_shield_power = 100.0
var shield_power = max_shield_power
var shield_alpha = 0.0
var ship_emission = 0.0
var shift_pressed = false
var missiles = 0


signal update_hud()
signal player_destroyed()


func init():
	shield.get_active_material(0).albedo_color.a = MIN_SHIELD_ALPHA
	for weapon in weapons_node.get_children():
		if weapon.name == "Main":
			weapon.active = true
		weapons.append(weapon)


func _input(_event):
	shift_pressed = true if Input.is_action_pressed("accelerate") else false


func _physics_process(delta):
	if shield_alpha > MIN_SHIELD_ALPHA:
		shield_alpha -= delta / 2.0
		shield_alpha = clampf(shield_alpha, MIN_SHIELD_ALPHA, MAX_SHIELD_ALPHA)
		shield.get_active_material(0).albedo_color.a = shield_alpha
	if ship_emission > MIN_EMISSION:
		ship_emission -= delta * 10
		ship_emission = clampf(ship_emission, MIN_EMISSION, MAX_EMISSION)
		set_emission()
	var speed = FAST_SPEED if shift_pressed else SPEED
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if velocity.x > 0:
		tilt_direction = 1.0
	elif velocity.x < 0:
		tilt_direction = -1.0
	else:  # if the ship doesn't move, revert the tilt direction
		if tilt > 0:
			tilt_direction = -1.0
		elif tilt < 0:
			tilt_direction = 1.0
		else:
			tilt_direction = 0
	var saved_tilt = tilt  # handle crossing zero tilt between frames
	tilt += tilt_direction * delta
	if saved_tilt > 0 and tilt < 0 or saved_tilt < 0 and tilt > 0:
		tilt = 0
		tilt_direction = 0
	if tilt > -MAX_TILT and tilt < MAX_TILT:
		rotation.z = tilt  # set rotation within max range
	else:
		tilt = clampf(tilt, -MAX_TILT, MAX_TILT)
	move_and_slide()


func activate_all_weapons():
	for weapon in weapons:
		weapon.active = true


func get_main_weapon():
	if weapons:
		for weapon in weapons:
			if weapon.name == "Main":
				return weapon
	return null


func shield_hit(value):
	# flash the shield (set a timer to change the alpha value continuously)
	shield_alpha = MAX_SHIELD_ALPHA
	shield_power -= value


func reset_material():
	ship_emission = MIN_EMISSION
	set_emission()


func set_emission():
	body_mesh.get_active_material(0).emission = Color(ship_emission, ship_emission, ship_emission, 1)


func activate_shield():
	shield_collision.set_deferred("enabled", true)
	shield.visible = true


func remove_shield():
	# use set_deferred or the shield won't stop receiving collision signals
	shield_power = 0  # to reset the possibly negative value
	shield_collision.set_deferred("disabled", true)
	shield.visible = false


func process_hit(area, enemy_impact):
	var value = get_hit_points(area, enemy_impact)
	if shield_power > 0:
		shield_hit(value)
		update_hud.emit()
		if shield_power <= 0:
			value = -shield_power
			remove_shield()
	if shield_power <= 0:
		hull_integrity -= value
		update_hud.emit()
		if hull_integrity <= 0:
			player_destroyed.emit()
	if enemy_impact:
		if hull_integrity > 0:
			area.explode()
	else:
		area.queue_free()  # bullets do not explode


func process_power_up(power_up):
	if power_up.shield_boost:
		if shield_power == 0:
			activate_shield()
		shield_power = clampf(shield_power + 20, 0, max_shield_power)
	if power_up.activate_side_weapons:
		activate_all_weapons()
	if power_up.add_missile:
		missiles += 1
	update_hud.emit()
	power_up.queue_free()


func get_hit_points(area, enemy_impact):
	return area.lifecycle.hit_points if enemy_impact else area.hit_points


func _on_area_3d_area_entered(area):
	var bullet_impact = area.is_in_group("ufo_bullet")
	var enemy_impact = area.is_in_group("enemy")
	var power_up_impact = area.is_in_group("powerups")
	if bullet_impact or enemy_impact:
		# handle the impact
		ship_emission = MAX_EMISSION
		process_hit(area, enemy_impact)  # get value from enemies
	elif power_up_impact:
		process_power_up(area)


func _on_shield_area_entered(area):
	var bullet_impact = area.is_in_group("ufo_bullet")
	var enemy_impact = area.is_in_group("enemy")
	if bullet_impact or enemy_impact:
		process_hit(area, enemy_impact)
