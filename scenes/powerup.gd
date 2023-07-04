class_name PowerUp
extends Area3D


var lifecycle = PowerUpLifecycle.new()

@export var shield_boost = 0.0
@export var activate_side_weapons = false
@export var add_missile = false


func init(enemy):
	position = enemy.global_position
	lifecycle.init(self)
	enemy.power_up = null  # to prevent multiple spawns if more bullets hit the enemy


func _process(delta):
	lifecycle.process(self, delta)
