extends Node2D

signal water_depth_changed(depth)

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var cell_size: int = 64
@export var num_types: int = 5
@export var initial_water_rows: int = 2
@export var swap_anim_time: float = 0.15

var grid: Array = []
var water: Array = []
var colors: Array[Color] = [
	Color("#e74c3c"),
	Color("#f1c40f"),
	Color("#2ecc71"),
	Color("#3498db"),
	Color("#9b59b6"),
]
var selected: Vector2i = Vector2i(-1, -1)

var current_water_depth: int = -1
var anim_layer: Node2D
var tile_tex: Texture2D
var board_layer: Node2D
var is_animating: bool = false
var water_shader: Shader
var water_material: ShaderMaterial

func _tile_color(idx: int) -> Color:
	var n: int = colors.size()
	if idx < 0:
		return Color(0, 0, 0, 0)
	if idx >= n:
		return colors[idx % n]
	return colors[idx]

func _ready() -> void:
	pass

@export var isset=false
func initData():
	randomize()
	var img := Image.create(1, 1, false, Image.FORMAT_RGBA8)
	img.fill(Color(1, 1, 1, 1))
	tile_tex = ImageTexture.create_from_image(img)
	board_layer = Node2D.new()
	add_child(board_layer)
	anim_layer = Node2D.new()
	add_child(anim_layer)
	board_layer.z_index = 0
	anim_layer.z_index = 100
	water_shader = Shader.new()
	water_shader.code = """
shader_type canvas_item;
uniform vec4 base_color = vec4(0.1, 0.6, 1.0, 0.22);
uniform float flow_speed = 0.5;
uniform float depth_darkness = 0.42;
uniform float depth_alpha_boost = 0.12;
uniform float bottom_slow = 0.65;
uniform float noise_scale = 4.0;
uniform int fbm_octaves = 4;

float hash(vec2 p){
	return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}
float noise2d(vec2 p){
	vec2 i = floor(p);
	vec2 f = fract(p);
	float a = hash(i);
	float b = hash(i + vec2(1.0,0.0));
	float c = hash(i + vec2(0.0,1.0));
	float d = hash(i + vec2(1.0,1.0));
	vec2 u = f*f*(3.0-2.0*f);
	return mix(a,b,u.x) + (c-a)*u.y*(1.0-u.x) + (d-b)*u.x*u.y;
}
float fbm(vec2 p, int oct){
	float v = 0.0;
	float a = 0.5;
	for(int i=0;i<8;i++){
		if(i>=oct) break;
		v += a * noise2d(p);
		p *= 2.0;
		a *= 0.5;
	}
	return v;
}

void fragment(){
	vec2 uv = UV;
	float depth = uv.y;
	float speed = mix(1.0, bottom_slow, depth);
	float t = TIME * flow_speed * speed;
	vec2 flow_uv = vec2(uv.x - t, uv.y);
	float n = fbm(flow_uv * noise_scale, fbm_octaves);
	float bright = 0.55 + 0.45 * n;
	float shade = 1.0 - depth_darkness * pow(depth, 1.35);
	vec3 col = base_color.rgb * bright * shade;
	float alpha = clamp(base_color.a + depth_alpha_boost * depth, 0.0, 1.0);
	COLOR = vec4(col, alpha);
}
"""
	water_material = ShaderMaterial.new()
	water_material.shader = water_shader
	_init_arrays()
	_spawn_initial_tiles()
	_init_water()
	_update_water_and_emit()
	_rebuild_visuals()
	set_process_input(true)
	isset=true
func clearData():
	for child in get_children():
		child.queue_free()
	isset=false
func _init_arrays() -> void:
	grid.resize(grid_height)
	water.resize(grid_height)
	for r in range(grid_height):
		grid[r] = []
		water[r] = []
		for c in range(grid_width):
			grid[r].append(-1)
			water[r].append(false)

func _spawn_initial_tiles() -> void:
	for r in range(grid_height):
		for c in range(grid_width):
			grid[r][c] = _random_tile_avoid(r, c)

func _random_tile_avoid(r: int, c: int) -> int:
	var banned: Dictionary = {}
	if c >= 2 and grid[r][c - 1] == grid[r][c - 2]:
		banned[grid[r][c - 1]] = true
	if r >= 2 and grid[r - 1][c] == grid[r - 2][c]:
		banned[grid[r - 1][c]] = true
	var choices: Array[int] = []
	for t in range(num_types):
		if not banned.has(t):
			choices.append(t)
	if choices.size() == 0:
		return int(randi() % num_types)
	return choices[int(randi() % choices.size())]

func _init_water() -> void:
	for r in range(initial_water_rows):
		for c in range(grid_width):
			water[r][c] = true

func _rebuild_visuals() -> void:
	for child in board_layer.get_children():
		if child is CanvasItem:
			child.visible = false
			child.queue_free()
	if current_water_depth >= 0:
		var bg := ColorRect.new()
		bg.material = water_material
		bg.size = Vector2(grid_width * cell_size, (current_water_depth + 1) * cell_size)
		bg.position = Vector2(0, 0)
		bg.z_index = -1
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		board_layer.add_child(bg)
	for r in range(grid_height):
		for c in range(grid_width):
			var pos := Vector2(c * cell_size, r * cell_size)
			if grid[r][c] >= 0:
				var tile := ColorRect.new()
				tile.color = _tile_color(grid[r][c])
				tile.size = Vector2(cell_size, cell_size)
				tile.position = pos
				tile.mouse_filter = Control.MOUSE_FILTER_IGNORE
				tile.z_index = 0
				board_layer.add_child(tile)
			if selected == Vector2i(r, c):
				var sel := Line2D.new()
				sel.width = 3.0
				sel.default_color = Color(1, 1, 1, 0.9)
				sel.z_index = 1
				sel.add_point(pos)
				sel.add_point(pos + Vector2(cell_size, 0))
				sel.add_point(pos + Vector2(cell_size, cell_size))
				sel.add_point(pos + Vector2(0, cell_size))
				sel.add_point(pos) # close loop
				board_layer.add_child(sel)


func _input(event: InputEvent) -> void:
	
	if not is_visible_in_tree():  # 检查节点及其父节点是否可见
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_animating:
			return
		var local_pos := to_local(get_global_mouse_position())
		var c := int(floor(local_pos.x / cell_size))
		var r := int(floor(local_pos.y / cell_size))
		if r < 0 or r >= grid_height or c < 0 or c >= grid_width:
			return
		_on_cell_clicked(Vector2i(r, c))

func _on_cell_clicked(cell: Vector2i) -> void:
	if grid[cell.x][cell.y] == -1:
		return
	if selected == Vector2i(-1, -1):
		selected = cell
		_rebuild_visuals()
	else:
		if _is_adjacent(selected, cell):
			var ok = await _try_swap(selected, cell)
			if ok:
				selected = Vector2i(-1, -1)
				_rebuild_visuals()
			else:
				selected = selected
		else:
			selected = cell
			_rebuild_visuals()

func _is_adjacent(a: Vector2i, b: Vector2i) -> bool:
	return abs(a.x - b.x) + abs(a.y - b.y) == 1

func _try_swap(a: Vector2i, b: Vector2i) -> bool:
	if not _would_swap_create_match(a, b):
		return false
	is_animating = true
	await _animate_swap(a, b)
	_swap_cells(a, b)
	is_animating = false
	_process_board_from(a, b)
	return true

func _would_swap_create_match(a: Vector2i, b: Vector2i) -> bool:
	var va: int = int(grid[a.x][a.y])
	var vb: int = int(grid[b.x][b.y])
	grid[a.x][a.y] = vb
	grid[b.x][b.y] = va
	var matches := _find_matches()
	var success := false
	for v in matches:
		if v == a or v == b:
			success = true
			break
	grid[a.x][a.y] = va
	grid[b.x][b.y] = vb
	return success

func _has_match_in_row_after_set(r: int, c: int, val: int) -> bool:
	var count: int = 1
	var cc: int = c - 1
	while cc >= 0:
		var cur_l: int = int(grid[r][cc])
		if cur_l == val:
			count += 1
			cc -= 1
		else:
			break
	cc = c + 1
	while cc < grid_width:
		var cur_r: int = int(grid[r][cc])
		if cur_r == val:
			count += 1
			cc += 1
		else:
			break
	return count >= 3

func _has_match_in_col_after_set(r: int, c: int, val: int) -> bool:
	var count: int = 1
	var rr: int = r - 1
	while rr >= 0:
		var cur_u: int = int(grid[rr][c])
		if cur_u == val:
			count += 1
			rr -= 1
		else:
			break
	rr = r + 1
	while rr < grid_height:
		var cur_d: int = int(grid[rr][c])
		if cur_d == val:
			count += 1
			rr += 1
		else:
			break
	return count >= 3

func _swap_cells(a: Vector2i, b: Vector2i) -> void:
	var t = grid[a.x][a.y]
	grid[a.x][a.y] = grid[b.x][b.y]
	grid[b.x][b.y] = t

func _find_matches() -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	for r in range(grid_height):
		var run_len := 1
		for c in range(1, grid_width):
			var cur = grid[r][c]
			var prev = grid[r][c - 1]
			if cur >= 0 and cur == prev:
				run_len += 1
			else:
				if run_len >= 3 and prev >= 0:
					for k in range(run_len):
						out.append(Vector2i(r, c - 1 - k))
				run_len = 1
		if run_len >= 3 and grid[r][grid_width - 1] >= 0:
			for k in range(run_len):
				out.append(Vector2i(r, grid_width - 1 - k))
	for c in range(grid_width):
		var run_len := 1
		for r in range(1, grid_height):
			var cur = grid[r][c]
			var prev = grid[r - 1][c]
			if cur >= 0 and cur == prev:
				run_len += 1
			else:
				if run_len >= 3 and prev >= 0:
					for k in range(run_len):
						out.append(Vector2i(r - 1 - k, c))
				run_len = 1
		if run_len >= 3 and grid[grid_height - 1][c] >= 0:
			for k in range(run_len):
				out.append(Vector2i(grid_height - 1 - k, c))
	var seen := {}
	var unique: Array[Vector2i] = []
	for v in out:
		var key = str(v.x) + "_" + str(v.y)
		if not seen.has(key):
			seen[key] = true
			unique.append(v)
	return unique

func _clear_matches(cells: Array[Vector2i]) -> void:
	for v in cells:
		grid[v.x][v.y] = -1

func _apply_gravity() -> void:
	for c in range(grid_width):
		var write_r := grid_height - 1
		for r in range(grid_height - 1, -1, -1):
			if grid[r][c] >= 0:
				grid[write_r][c] = grid[r][c]
				if write_r != r:
					grid[r][c] = -1
				write_r -= 1
	_sanitize_grid()

func _update_water_and_emit() -> void:
	for c in range(grid_width):
		var prev_indices: Array[int] = []
		var prev_count := 0
		for r in range(grid_height):
			if water[r][c]:
				prev_indices.append(r)
				prev_count += 1
			water[r][c] = false
		if prev_count == 0:
			continue
		var empty_rows: Array[int] = []
		for r in range(grid_height):
			if grid[r][c] == -1:
				empty_rows.append(r)
		empty_rows.sort()
		if empty_rows.size() == 0:
			for rr in prev_indices:
				water[rr][c] = true
		else:
			for i in range(min(prev_count, empty_rows.size())):
				var idx := empty_rows.size() - 1 - i
				var rr := empty_rows[idx]
				water[rr][c] = true
	var depth := -1
	for r in range(grid_height - 1, -1, -1):
		for c in range(grid_width):
			if water[r][c]:
				depth = max(depth, r)
	var right_depth := -1
	if grid_width > 0:
		var rc := grid_width - 1
		for r in range(grid_height - 1, -1, -1):
			if water[r][rc]:
				right_depth = r
				
				#right_depth = max(right_depth, r)  
				
				#break
	

		current_water_depth = depth
		water_depth_changed.emit(right_depth)
	else:
		current_water_depth = depth

func _process_board() -> void:
	while true:
		var matches := _find_matches()
		if matches.size() == 0:
			break
		_clear_matches(matches)
		_apply_gravity()
		_apply_right_compaction()
	_update_water_and_emit()
	_rebuild_visuals()

func _process_board_from(a: Vector2i, b: Vector2i) -> void:
	var first := true
	while true:
		var matches := _find_matches()
		if matches.size() == 0:
			break
		if first:
			var filtered := _filter_matches_connected_to(matches, [a, b])
			if filtered.size() == 0:
				break
			_clear_matches(filtered)
			first = false
		else:
			_clear_matches(matches)
		_apply_gravity()
		_apply_right_compaction()
	_update_water_and_emit()
	_rebuild_visuals()

func _filter_matches_connected_to(matches: Array[Vector2i], origins: Array[Vector2i]) -> Array[Vector2i]:
	var set := {}
	for v in matches:
		set[str(v.x) + "_" + str(v.y)] = true
	var visited := {}
	var queue: Array[Vector2i] = []
	for o in origins:
		var k := str(o.x) + "_" + str(o.y)
		if set.has(k):
			queue.append(o)
			visited[k] = true
	var out: Array[Vector2i] = []
	while queue.size() > 0:
		var cur: Vector2i = queue.pop_front()
		out.append(cur)
		var nx := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
		for d in nx:
			var nv := Vector2i(cur.x + d.x, cur.y + d.y)
			var nk := str(nv.x) + "_" + str(nv.y)
			if not visited.has(nk) and set.has(nk):
				visited[nk] = true
				queue.append(nv)
	return out

func _apply_right_compaction() -> void:
	for r in range(grid_height):
		var write_c := grid_width - 1
		for c in range(grid_width - 1, -1, -1):
			if grid[r][c] >= 0:
				grid[r][write_c] = grid[r][c]
				if write_c != c:
					grid[r][c] = -1
				write_c -= 1
	_sanitize_grid()

func _sanitize_grid() -> void:
	for r in range(grid_height):
		for c in range(grid_width):
			var v = grid[r][c]
			if v < -1:
				grid[r][c] = -1
			elif v >= num_types:
				grid[r][c] = v % num_types

func _get_cell_visual_pos(r: int, c: int) -> Vector2:
	return Vector2(c * cell_size + cell_size * 0.5, r * cell_size + cell_size * 0.5)

func _animate_swap(a: Vector2i, b: Vector2i) -> void:
	var color_a = _tile_color(grid[a.x][a.y])
	var color_b = _tile_color(grid[b.x][b.y])
	var rect_a := Sprite2D.new()
	rect_a.texture = tile_tex
	rect_a.modulate = color_a
	rect_a.scale = Vector2(cell_size, cell_size)
	rect_a.position = _get_cell_visual_pos(a.x, a.y)
	rect_a.z_index = 40
	anim_layer.add_child(rect_a)
	var rect_b := Sprite2D.new()
	rect_b.texture = tile_tex
	rect_b.modulate = color_b
	rect_b.scale = Vector2(cell_size, cell_size)
	rect_b.position = _get_cell_visual_pos(b.x, b.y)
	rect_b.z_index = 40
	anim_layer.add_child(rect_b)

	var tween = create_tween()
	tween.parallel().tween_property(rect_a, "position", _get_cell_visual_pos(b.x, b.y), swap_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(rect_b, "position", _get_cell_visual_pos(a.x, a.y), swap_anim_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	if is_instance_valid(rect_a):
		rect_a.queue_free()
	if is_instance_valid(rect_b):
		rect_b.queue_free()
