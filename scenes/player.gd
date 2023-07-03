extends CharacterBody3D


const SPEED = 30.0


@onready var weapons_node = $Weapons

var weapons = []


signal player_destroyed()


func init():
	for weapon in weapons_node.get_children():
		if weapon.name == "Main":
			weapon.active = true
		weapons.append(weapon)


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_area_3d_area_entered(area):
	player_destroyed.emit()
