extends Node
class_name BaseLevel


var timeline = []
var elapsed_time = 0.0
var previous_second = 0
var quads_removed = false


func process(node, delta):
	# check the lifecycle timeline by the elapsed time (since the level start)
	elapsed_time += delta
	if not quads_removed and elapsed_time > 10:
		LevelManager.remove_quads()
		quads_removed = true
	if elapsed_time - previous_second > 1.0:
		previous_second += 1
		for event in timeline:
			if event.timestamp <= elapsed_time and !event.has("processed"):
				process_wave(node, event.wave)
				event.processed = true


func process_wave(node, wave):
	for item in wave:
		var enemy = item.enemy.instantiate()
		enemy.init(node, item.spawn, item.timeline)
		node.add_child(enemy)
