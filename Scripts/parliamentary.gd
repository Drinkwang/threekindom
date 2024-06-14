extends Control
#创建3个类 代表三个派系 初始解锁2个
@onready var p_1 = $PanelContainer/Label/Label2/p1
@onready var p_2 = $PanelContainer/Label/Label2/p2
@onready var p_3 = $PanelContainer/Label/Label2/p3
@onready var o_1 = $PanelContainer/Label/Label2/o1

const BENTUPAI = preload("res://Asset/tres/bentupai.tres")
const HAOZUPAI = preload("res://Asset/tres/haozupai.tres")
const WAIDIPAI = preload("res://Asset/tres/waidipai.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	p_1.text="%d\n111"%1  #本土派
	p_2.text="" #外来派
	
	pass # Replace with function body.

#在进入瞬间判断出结果，然后做一个动画

func enter():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
