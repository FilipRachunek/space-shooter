extends Node3D


@onready var debug_overlay = $debug
@onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_boundary(
		$"Boundary/LeftWall".position.x,
		$"Boundary/RightWall".position.x,
		$"Boundary/TopWall".position.z,
		$"Boundary/BottomWall".position.z
	)
	debug_overlay.init(player)
	GameManager.spawn_stars(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	GameManager.process_background(self, delta)
