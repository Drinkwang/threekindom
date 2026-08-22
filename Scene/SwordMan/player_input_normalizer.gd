extends RefCounted


static func calculate_velocity(
	input_delta: Vector2,
	sample_interval: float,
	max_speed: float
) -> Vector2:
	var safe_interval := maxf(sample_interval, 0.000001)
	return (input_delta / safe_interval).limit_length(maxf(max_speed, 0.0))
