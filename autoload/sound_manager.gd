extends Node


@onready var bullet_sound = $BulletSound
@onready var metal_hit_sound = [$MetalHit1Sound, $MetalHit2Sound]
@onready var rock_hit_sound = [$RockHit1Sound, $RockHit2Sound, $RockHit3Sound]
@onready var explosion_sound = $ExplosionSound
@onready var missile_sound = $MissileSound


func fire_bullet():
	bullet_sound.play()


func fire_missile():
	missile_sound.play()


func metal_hit_effect():
	var sound = metal_hit_sound.pick_random()
	sound.pitch_scale = randf_range(0.8, 1.2)
	sound.play()


func rock_hit_effect():
	var sound = rock_hit_sound.pick_random()
	sound.pitch_scale = randf_range(0.8, 1.2)
	sound.play()


func explode():
	explosion_sound.play()
