extends Control

@onready var board: Node2D = $Board
@onready var farmland_panel: Control = $FarmlandPanel
@onready var victory_label: Label =  $PanelContainer/Label2

#var connector: ColorRect
var conn_shader: Shader
var conn_material: ShaderMaterial

func _ready() -> void:
	victory_label.visible = false
	board.connect("water_depth_changed", Callable(self, "_on_water_depth_changed"))
	for child in farmland_panel.get_children():
		if child is Control and child.has_method("update_irrigation"):
			child.set("cell_size", board.get("cell_size"))
			child.set("max_depth", board.get("grid_height") - 1)
			var req := int(child.get("required_depth"))
			child.position.y = float(req) * float(board.get("cell_size"))
	conn_shader = Shader.new()
	conn_shader.code = """
shader_type canvas_item;
uniform vec4 base_color = vec4(0.1, 0.6, 1.0, 0.22);
uniform float flow_speed = 0.5;
uniform float noise_scale = 4.0;
uniform int fbm_octaves = 3;

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
	float t = TIME * flow_speed;
	vec2 flow_uv = vec2(uv.x - t, uv.y);
	float n = fbm(flow_uv * noise_scale, fbm_octaves);
	float bright = 0.55 + 0.45 * n;
	vec3 col = base_color.rgb * bright;
	COLOR = vec4(col, base_color.a);
}
"""
	conn_material = ShaderMaterial.new()
	conn_material.shader = conn_shader
	#switch_Difficult()
	#_update_connector(-1)
@onready var timer: Timer = $Timer




@onready var resideTimeLabel: Label = $PanelContainer/Label2

func _on_timeout():
	if isvictory==true:
		return
	time_left -= 1
	resideTimeLabel.text = tr("剩余时间:{s}秒").format({"s":time_left})  # 每秒更新UI（极省性能）
	if time_left <= 0:
		timer.stop()
		loseGame()  # 超时逻辑：失败、显示星星
var time_left=0
func initGame():
	switch_Difficult()
	timer.wait_time = 1.0
	timer.one_shot = false  # 重复触发
	time_left=60
	timer.timeout.connect(_on_timeout)  # 连接信号（编辑器也可连）
	timer.start()  # 启动（autostart=true也可）

func _on_water_depth_changed(depth: int) -> void:
	var all_done := true
	for child in farmland_panel.get_children():
		if child is Control and child.has_method("update_irrigation"):
			child.update_irrigation(depth)
			if not child.irrigated and child.visible==true:
				all_done = false
	for i in range(0,depth+1):
		_update_connector(depth)
	if all_done:
		_show_victory()

@onready var win_rect: ColorRect = $winRect
@onready var blink_rect: TextureRect = $winRect/blinkRect
@onready var blink_animation_player: AnimationPlayer = $winRect/blinkRect/AnimationPlayer

var isvictory=false
func _show_victory() -> void:
	isvictory=true
	timer.stop()
	win_rect.show()
	blink_rect.show()
	blink_animation_player.play("win")
	var finishfunc=func(aniname):
		blink_rect.hide()
	blink_animation_player.animation_finished.connect(finishfunc)	
	

	SoundManager.play_sound(sounds.GOOD_THING)	
	
@onready var colorrect: Control = $colorrect
@onready var color_rect_1: ColorRect = $colorrect/ColorRect3
@onready var color_rect_2: ColorRect = $colorrect/ColorRect4
@onready var color_rect_3: ColorRect = $colorrect/ColorRect5

func _get_first_visible_farmland(deep) -> Control:
	for child in farmland_panel.get_children():
		if child is Control and child.visible and child.has_method("update_irrigation") and deep==child.required_depth:
			#return child
			if deep==1:
				return color_rect_1
			elif deep==3:
				return color_rect_2
			elif deep==5:
				return color_rect_3	
	return null


func switch_Difficult():
	var difficult=GameManager.selectPuzzleDiffcult
	var farmlands=farmland_panel.get_children()
	var colorrects=colorrect.get_children()	
	if difficult==SceneManager.puzzlediffucult.easy:

		farmlands[0].show()
		colorrects[0].show()
		for i in range(1,3):
			farmlands[i].hide()
			colorrects[i].hide()
	elif difficult==SceneManager.puzzlediffucult.middle:
		for i in range(0,2):
			farmlands[i].show()
			colorrects[i].show()
		farmlands[2].hide()
		colorrects[2].hide()	
	elif difficult==SceneManager.puzzlediffucult.high:
		for i in range(0,3):
			farmlands[i].show()
			colorrects[i].show()

func _update_connector(depth: int) -> void:
	var target := _get_first_visible_farmland(depth)
	if target == null:
	
		return
	var cs: int = int(board.get("cell_size"))
	var gh: int = int(board.get("grid_height"))
	var bw: int = int(board.get("grid_width"))
	var board_right := board.position.x + float(bw * cs)
	var panel_x := farmland_panel.position.x
	var gap = max(8.0, panel_x - board_right - 6.0)
	var h := float(cs) * 0.25
	var y := board.position.y + target.position.y + float(cs) * 0.5 - h * 0.5

	if target.color!=Color(0.6, 0.6, 0.6, 1.0):
		target.material = conn_material
		target.color = Color(0.6, 0.6, 0.6, 1.0)
		pass

@onready var lose_rect: ColorRect = $LoseRect

func loseGame():
	lose_rect.show()
	timer.stop()

func _on_afterWin_button_down() -> void:
	if GameManager.sav.constructRiver<GameManager.selectPuzzleDiffcult:
		var tc=0
		if GameManager.sav.constructRiver==1:
			tc=10
		elif GameManager.sav.constructRiver==2:
			tc=20
		elif GameManager.sav.constructRiver==3:
			tc=30
		
		if GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.easy:
			GameManager.resideValue=10
		elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.middle:
			GameManager.resideValue=20
		elif GameManager.selectPuzzleDiffcult==SceneManager.puzzlediffucult.high:
			GameManager.resideValue=30
		var allDayget=GameManager.resideValue-tc
		GameManager.sav.labor_DayGet+=allDayget
		GameManager.sav.constructTower=GameManager.selectPuzzleDiffcult

	else:
		#无奖励
		GameManager.resideValue=0
	self.hide()
	DialogueManager.show_dialogue_balloon(GameManager.sys,"基建挖河成功")


func _on_lose_button_down() -> void:
	DialogueManager.show_dialogue_balloon(GameManager.sys,"基建挖河失败")
	self.hide()


func _on_giveup_button_down() -> void:
	DialogueManager.show_dialogue_balloon(GameManager.sys,"放弃基建")
