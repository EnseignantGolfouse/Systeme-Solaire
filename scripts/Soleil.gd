extends Sprite


export var mercure_period: int = 88
export var venus_period: int = 220
export var terre_period: int = 365


func set_planets_positions(days: int) -> void:
	$MercurePivot.rotation = float(days % mercure_period) * 2 * PI / float(mercure_period)
	$VenusPivot.rotation = float(days % venus_period) * 2 * PI / float(venus_period)
	$TerrePivot.rotation = float(days % terre_period) * 2 * PI / float(terre_period)
