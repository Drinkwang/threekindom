extends RefCounted


static func calculate_delta_position(
	current_position: Vector2,
	requested_delta: Vector2,
	max_speed: float,
	delta: float,
	arena: Rect2,
	margin: float
) -> Vector2:
	var max_distance := maxf(max_speed, 0.0) * maxf(delta, 0.0)
	var next_position := current_position + requested_delta.limit_length(max_distance)
	var safe_margin := maxf(margin, 0.0)
	return Vector2(
		clampf(next_position.x, arena.position.x + safe_margin, arena.end.x - safe_margin),
		clampf(next_position.y, arena.position.y + safe_margin, arena.end.y - safe_margin)
	)
