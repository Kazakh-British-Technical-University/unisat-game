extends Tween

func StartGlow():
	$Glow.visible = true
	interpolate_method(self, "GlowPulse", 0, 1, 2)
	start()

func GlowPulse(t):
	$Glow.scale = Vector2.ONE * (1.5 + sin(2 * t * PI)/2)
