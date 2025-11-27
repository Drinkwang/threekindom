# Main.gd
extends Control

# 导出变量 - Godot 4 语法
@export var source_texture: Texture2D  # 源图片
@export var rows: int = 3              # 行数
@export var cols: int = 3              # 列数
@export var piece_size: Vector2 = Vector2(100, 100)  # 拼图块大小

# 拼图块数组
var puzzle_pieces: Array = []

# 拼图块原始位置
var original_positions: Array = []
@export var ShuffleButton:Button
@export var ResetButton:Button
@export var PiecesContainer:Node2D
func _ready():
	# 确保有源图片
	if source_texture:
		create_puzzle()
	else:
		print("请设置源图片")
	
	# 连接UI按钮信号 - Godot 4 语法
	ShuffleButton.pressed.connect(_on_shuffle_button_pressed)
	ResetButton.pressed.connect(_on_reset_button_pressed)



var tempclopos=null
var clopos=null
func _process(delta: float) -> void:
	
	var moupos=get_viewport().get_mouse_position()
	#if mouseline.visible==true:
		#
		#if istutorial==false:
			#border.position=moupos	
	if selectPiece!=null:
		selectPiece.position=moupos-Vector2(648,248)
		
		#selectPiece.z_index = 100  # 最上层，先拾取
		clopos=checkMinPos(selectPiece.position)
		if clopos!=null and tempclopos!=clopos:
			tempclopos=clopos
			if visualClubPos!=null:
				visualClubPos.queue_free()
			visualClubPos= selectPiece.duplicate(true)   # 直接复制当前棋子

			for child in visualClubPos.get_children():
				child.queue_free()
			visualClubPos.modulate = Color(1, 1, 1, 0.5)   # 50% 透明度
			#visualClubPos.z_index = -100  # 极低 Z 值，确保在所有棋盘/背景之上但棋子之下
			
			visualClubPos.process_mode = Node.PROCESS_MODE_DISABLED
			#visualClubPos.input_pickable = false  # 鼠标穿透
			#set_pickable_recursively(visualClubPos, false)
		
		# 6. 添加到当前节点（或底层容器，如 $Board 或 $Background）
			add_child(visualClubPos)  # 如果有专用底层节点：$BackgroundLayer.add_child(preview_piece)
			visualClubPos.position = clopos+Vector2(648,248)
			visualClubPos.name = "PreviewPiece"
		elif clopos==null:
			tempclopos=null
			if visualClubPos!=null:
				visualClubPos.queue_free()
			
	pass
var visualClubPos=null
# 拆两个函数方便维护
func _add_grid_background():
	var grid_bg = NinePatchRect.new()
	grid_bg.name = "PuzzleGridBG"
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0.2)
	style.border_width_left =3
	style.border_width_right =3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_color = Color(0.15, 0.15, 0.15)
	grid_bg.add_theme_stylebox_override("panel", style)
	grid_bg.size = Vector2(cols * piece_size.x, rows * piece_size.y)
	PiecesContainer.add_child(grid_bg)
func _add_grid_lines():
	# 彻底删除旧的
	for child in PiecesContainer.get_children():
		if child.name.begins_with("GridLine_"):
			child.queue_free()
	
	var color = Color(0.98, 0.92, 0.78, 0.95)
	var width = 6
	
	# 画垂直线（cols+1 条）
	for i in range(cols + 1):
		var line = Line2D.new()
		line.name = "GridLine_V_%d" % i
		line.width = width
		line.default_color = color
		line.antialiased = true
		line.add_point(Vector2(i * piece_size.x, 0))
		line.add_point(Vector2(i * piece_size.x, rows * piece_size.y))
		PiecesContainer.add_child(line)
	
	# 画水平线（rows+1 条）
	for i in range(rows + 1):
		var line = Line2D.new()
		line.name = "GridLine_H_%d" % i
		line.width = width
		line.default_color = color
		line.antialiased = true
		line.add_point(Vector2(0, i * piece_size.y))
		line.add_point(Vector2(cols * piece_size.x, i * piece_size.y))
		PiecesContainer.add_child(line)
# 创建拼图
func create_puzzle():
	# 清空现有拼图块
	for child in PiecesContainer.get_children():
		child.queue_free()
	puzzle_pieces.clear()
	original_positions.clear()
	piece_size = Vector2(600.0 / cols, 600.0 / rows)   # ← 这里改成你想要的最终显示尺寸
	#if source_texture:
		#piece_size = Vector2(
			#source_texture.get_width() / float(cols),
			#source_texture.get_height() / float(rows)
		#)
	var real_w = source_texture.get_width() / float(cols)
	var real_h = source_texture.get_height() / float(rows)
	_add_grid_background()
	# 计算拼图块尺寸
	var img_width = source_texture.get_width()
	var img_height = source_texture.get_height()
	var actual_piece_width = img_width / cols
	var actual_piece_height = img_height / rows
	
	# 创建拼图块
	for row in range(rows):
		for col in range(cols):
			# 跳过最后一个位置（作为空位）
			#if row == rows - 1 and col == cols - 1:
			#	empty_slot_index = row * cols + col
			#	continue
				
			# 创建拼图块精灵 - Godot 4 使用 Sprite2D
			var piece = Sprite2D.new()
			piece.texture = source_texture
			piece.region_enabled = true
			piece.region_rect = Rect2(
				col * actual_piece_width,
				row * actual_piece_height,
				actual_piece_width,
				actual_piece_height
			)
			
			# 设置位置
			var board_pos =Vector2(col * piece_size.x, row * piece_size.y) + piece_size * 0.5
			
			piece.position = board_pos

			piece.scale = Vector2(piece_size.x / real_w, piece_size.y / real_h)
			piece.centered = true
			# 添加到场景和数组
			PiecesContainer.add_child(piece)
			puzzle_pieces.append(piece)
			original_positions.append(board_pos)
			
			# 添加点击检测区域 - Godot 4 语法
			var area = Area2D.new()

			var collision = CollisionShape2D.new()
			var shape = RectangleShape2D.new()

			
			#area.input_pickable = true   # 必须打开！默认是 false
#
			#area.collision_layer = 0          # 不需要碰撞层
			#area.collision_mask = 0           # 不需要检测其他物体
			#area.monitoring = true
			#area.monitorable = false          # 重要！不让别人检测到自己（减少事件）

# 关键设置：让 Area2D 优先级更高（z_index 越大越先收到事件）
			area.priority = 100               # 数值越大越靠前（默认是 0）

			
			shape.size = Vector2(actual_piece_width,actual_piece_height)
			collision.shape = shape
			area.add_child(collision)
			piece.add_child(area)
			
			
			#disable_input_recursively(piece)
			
			# 连接信号 - Godot 4 语法
			area.input_event.connect(_on_piece_input_event.bind(piece))

	
	_add_grid_lines()
	#original_positions.append(Vector2((cols-1) * piece_size.x, (rows-1) * piece_size.y))
	# 初始打乱拼图
	movetoDeck()
# 每当你设置拼图块的 z_index 时，同时同步到它的 Area2D
func set_piece_z_index(piece: Node2D, z: int):
	piece.z_index = z
	var area = piece.get_node("Area2D")  # 确保名字一致
	if area:
		area.priority = z * 10           # 放大一点防止冲突，比如 z=1 → priority=10
var selectPiece=null
# 处理拼图块输入事件 - Godot 4 参数顺序变化
func _on_piece_input_event(viewport: Node, event: InputEvent, shape_idx: int, piece: Sprite2D):
	#print("haveClickEvent")
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and selectPiece==null and canclick==true:
		#try_move_piece(piece)#选中图块，跟手，tick阶段判断拼图和场上块接近么接近，发挥效果，并拼上
		if selectPiece==null:
			selectPiece=piece
			canclick=false
			await  get_tree().create_timer(0.5).timeout
			canclick=true
			set_piece_z_index(piece, 999)

func checkMinPos(opos):
	var closest_pos: Vector2 = original_positions[0]
	var min_dist_sq: float = original_positions[0].distance_squared_to(opos)

	for pos in original_positions:
		var d = pos.distance_squared_to(opos)
		if d < min_dist_sq:
			min_dist_sq = d
			closest_pos = pos
	for piece in puzzle_pieces:
		if piece != selectPiece:  # 排除自己（正在拖的那块）
			if piece.position == closest_pos:   # 完全相等（Vector2 精确比较）

				return null  # 被占用 → 不允许吸附，返回 null
	
	if min_dist_sq<12000:
		return closest_pos
	else:
		return null

# 尝试移动拼图块
#func try_move_piece(piece: Sprite2D):
	#var piece_index = puzzle_pieces.find(piece)
	#if piece_index == -1:
		#return
		#
	#var piece_pos = piece.position
	#var empty_pos = original_positions[empty_slot_index]
	#
	## 检查是否与空位相邻
	#if is_adjacent(piece_pos, empty_pos):
		## 交换位置
		#var target_pos = empty_pos
		#empty_pos = piece_pos
		#piece.position = target_pos
		#
		## 更新空位索引
		#empty_slot_index = get_position_index(piece_pos)
		#
		## 检查是否完成拼图
		##check_puzzle_complete()

# 检查两个位置是否相邻
func is_adjacent(pos1: Vector2, pos2: Vector2) -> bool:
	var diff = pos1 - pos2
	return (abs(diff.x) <= piece_size.x + 1 and abs(diff.y) < 5) or \
		   (abs(diff.y) <= piece_size.y + 1 and abs(diff.x) < 5)

# 获取位置对应的索引
func get_position_index(pos: Vector2) -> int:
	for i in range(original_positions.size()):
		if original_positions[i] == pos:
			return i
	return -1


func movetoDeck():
	for i in range(0,puzzle_pieces.size()):
		var piece=puzzle_pieces[i]
		piece.position=Vector2(-160,100+i*50)
	#for piece in puzzle_pieces:
		#pass

# 打乱拼图

	# 执行多次随机移动来打乱拼图
	#for i in range(1000):
		#var adjacent_pieces = get_adjacent_pieces()
		#if adjacent_pieces.size() > 0:
			#var random_piece = adjacent_pieces[randi() % adjacent_pieces.size()]
			#try_move_piece(random_piece)

## 获取与空位相邻的拼图块
#func get_adjacent_pieces() -> Array:
	#var adjacent = []
	#var empty_pos = original_positions[empty_slot_index]
	#
	#for piece in puzzle_pieces:
		#if is_adjacent(piece.position, empty_pos):
			#adjacent.append(piece)
			#
	#return adjacent

# 检查拼图是否完成
func check_puzzle_complete():
	for i in range(puzzle_pieces.size()):
		if puzzle_pieces[i].position != original_positions[i]:
			return
			
	# 所有拼图块都在正确位置
	print("拼图完成!")
	# 可以在这里添加完成效果或回调

# UI按钮功能 - Godot 4 信号连接方法
func _on_shuffle_button_pressed():
	movetoDeck()

func _on_reset_button_pressed():
	# 重置拼图到初始状态
	for i in range(puzzle_pieces.size()):
		puzzle_pieces[i].position = original_positions[i]
	#empty_slot_index = rows * cols - 1
	check_puzzle_complete()
@export var normal_color: Color = Color(0.95, 0.95, 0.95)  # 常态背景色（浅灰）
@export var hover_color: Color = Color(0.85, 0.3, 0.3)    # Hover 背景色（暗红，符合三国风）
@export var press_color: Color = Color(0.7, 0.2, 0.2)     # 按压背景色（深暗红）
@export var press_scale: float = 0.95                     # 按压时缩放比例（轻微缩小）

func _on_giveup_button_mouse_entered() -> void:
	_update_bg_color(hover_color)


func _on_giveup_button_mouse_exited() -> void:
	_update_bg_color(normal_color)


func _on_giveup_button_down() -> void:
	_update_bg_color(press_color)
	if tween!=null:
		tween.kill()  # 终止之前的过渡，避免冲突	
	tween = create_tween()
	tween.tween_property(texture_button,"scale",Vector2(1.2,1.2),0.05)
	tween.tween_property(texture_button,"scale",Vector2(1,1),0.05)
	#tween.tween_property(texture_button,"scale",1.0,1)
var tween: Tween  # 用于平滑颜色过渡
@onready var texture_button: TextureButton = $SettleButton

func _update_bg_color(target_color: Color):
	if tween!=null:
		tween.kill()  # 终止之前的过渡，避免冲突
	tween = create_tween()
	tween.tween_property(texture_button,"modulate",target_color,0.05)


func _on_rotate_button_button_down() -> void:
	pass # Replace with function body.

var canclick=true
func _input(event: InputEvent) -> void:
	var isstop:bool=true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and canclick==true:
		if selectPiece!=null:
	


			if visualClubPos!=null:
				visualClubPos.queue_free()
		
				tempclopos=null

				set_piece_z_index(selectPiece, 0)
				selectPiece.position = clopos#+Vector2(648,248)
				selectPiece=null
				canclick=false
				await  get_tree().create_timer(0.5).timeout
				canclick=true
		#判断离所有方格，且小于50 则强行变位

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and selectPiece!=null:
		set_piece_z_index(selectPiece, 0)
		selectPiece=null
		tempclopos=null
		
		if visualClubPos!=null:
			visualClubPos.queue_free()
#func disable_input_recursively(node: Node):
	## 只在物理碰撞对象上禁用输入拾取（Area2D 等）
	#if node is CollisionObject2D:
		#node.input_pickable = false
		#if node is Area2D:
			#node.monitoring = false
			#node.monitorable = false
	#
	## Control 节点：忽略鼠标
	#if node is Control:
		#node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	#
	## 递归所有子节点
	#for child in node.get_children():
		#disable_input_recursively(child)
