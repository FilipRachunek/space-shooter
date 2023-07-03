extends CanvasLayer


@onready var player_hull_integrity = $Player/GridContainer/HullIntegrityBar
@onready var player_shield_power = $Player/GridContainer/ShieldPowerBar


func set_player_values(player):
	tween_property(player_hull_integrity, "value", player.hull_integrity)
	tween_property(player_shield_power, "value", player.shield_power)


func tween_property(element, property, value):
	if value != element.get(property):
		var tween = get_tree().create_tween()
		tween.tween_property(element, "value", value, 1)
