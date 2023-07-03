extends Node3D


@onready var debug_overlay = $debug
@onready var player = $player

var fire_cadence = 0.2
var fire_cooldown = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_boundary(
		$"Boundary/LeftWall".position.x,
		$"Boundary/RightWall".position.x,
		$"Boundary/TopWall".position.z,
		$"Boundary/BottomWall".position.z
	)
	debug_overlay.init(player)
	player.connect("player_destroyed", Callable(self, "_on_player_destroyed"))
	player.init()
	GameManager.set_player(player)
	GameManager.spawn_stars(self)
	GameManager.spawn_asteroids(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	GameManager.process_background(self, delta)
	if Input.is_action_pressed("shoot_primary") and fire_cooldown <= 0:
		fire_bullet()
	fire_cooldown -= delta


func fire_bullet():
	if Utils.is_valid_node(player):
		fire_cooldown = fire_cadence
		GameManager.fire_player_weapon(self)


func _on_player_destroyed():
	player.queue_free()


func _on_enemy_destroyed(enemy):
	GameManager.create_explosion(self, enemy, 15, 15)


func _on_show_hit_effect(enemy, bullet):
	GameManager.create_hit_effect(self, enemy, bullet)
