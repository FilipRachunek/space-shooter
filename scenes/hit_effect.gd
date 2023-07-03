extends CPUParticles3D


var elapsed_time = 0.0


func init(x, z):
	# increase the Y coordinate to put the sparks above the scene objects
	translate(Vector3(x, 10, z))
	emitting = true
	restart()  # to resolve certain visual issues


func _physics_process(delta):
	elapsed_time += delta
	if elapsed_time > 0.5:
		emitting = false
		queue_free()
