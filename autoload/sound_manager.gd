extends Node


@onready var bullet_sound = $BulletSound
@onready var metal_hit_sound = [$MetalHit1Sound, $MetalHit2Sound]
@onready var rock_hit_sound = [$RockHit1Sound, $RockHit2Sound, $RockHit3Sound]
@onready var explosion_sound = $ExplosionSound
@onready var missile_sound = $MissileSound
@onready var intro_song = $IntroSong

var master_bus
var music_bus
var sfx_bus


func _ready():
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("Sfx")


func init_sound_system():
	set_master_volume()
	set_music_volume()
	set_sfx_volume()


func set_master_volume(value = -1):
	if value == -1:
		value = OptionsManager.get_master_volume()
	# the value is between 0 and 1
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func set_music_volume(value = -1):
	if value == -1:
		value = OptionsManager.get_music_volume()
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))


func set_sfx_volume(value = -1):
	if value == -1:
		value = OptionsManager.get_sfx_volume()
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))


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


func fade_in_intro_song(position = 0.0):
	if not intro_song.playing:
		intro_song.volume_db = -20
		intro_song.play(position)
		var tween = get_tree().create_tween()
		tween.tween_property(intro_song, "volume_db", 0, 1)


func fade_out_intro_song():
	if intro_song.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(intro_song, "volume_db", -40, 3)
		tween.tween_callback(intro_song.stop)
