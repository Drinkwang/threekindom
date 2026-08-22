extends RefCounted


static func calculate_position(
	current_position: Vector2,
	target_position: Vector2,
	speed: float,
	delta: float,
	arena: Rect2,
	margin: float
) -> Vector2:
	var clamped_target := clamp_to_arena(target_position, arena, margin)
	if speed <= 0.0:
		return clamped_target
	var next_position := current_position.move_toward(clamped_target, speed * maxf(delta, 0.0))
	return clamp_to_arena(next_position, arena, margin)


static func calculate_delta_position(
	current_position: Vector2,
	requested_delta: Vector2,
	speed: float,
	delta: float,
	arena: Rect2,
	margin: float
) -> Vector2:
	var limited_delta := limit_delta(requested_delta, speed, delta)
	return clamp_to_arena(current_position + limited_delta, arena, margin)


static func limit_delta(requested_delta: Vector2, speed: float, delta: float) -> Vector2:
	var max_distance := maxf(speed, 0.0) * maxf(delta, 0.0)
	return requested_delta.limit_length(max_distance)


static func buffer_input_delta(
	pending_delta: Vector2,
	incoming_delta: Vector2,
	speed: float,
	render_delta: float,
	physics_delta: float,
	max_buffer_seconds: float
) -> Vector2:
	var safe_physics_delta := maxf(physics_delta, 0.000001)
	var input_window := clampf(render_delta, safe_physics_delta, max_buffer_seconds)
	var accepted_input := limit_delta(incoming_delta, speed, input_window)
	var buffer_window := minf(input_window + safe_physics_delta, max_buffer_seconds)
	return limit_delta(pending_delta + accepted_input, speed, buffer_window)


static func clamp_to_arena(position_to_clamp: Vector2, arena: Rect2, margin: float) -> Vector2:
	var safe_margin := maxf(margin, 0.0)
	var axis_margin := Vector2(
		minf(safe_margin, arena.size.x * 0.5),
		minf(safe_margin, arena.size.y * 0.5)
	)
	var min_position := arena.position + axis_margin
	var max_position := arena.end - axis_margin
	return Vector2(
		clampf(position_to_clamp.x, min_position.x, max_position.x),
		clampf(position_to_clamp.y, min_position.y, max_position.y)
	)
