extends Camera2D

var ramdom_strength:float #força da tremida
var shake_fade:float = 5 #tempo para a camera para de tremer

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0

func aply_shake(strength:float):
	ramdom_strength = strength
	shake_strength = ramdom_strength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = ramdom_offset()

func ramdom_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
