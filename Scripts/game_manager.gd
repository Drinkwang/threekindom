extends Node

#GameManager
var day

var intellectual_support #士族支持度 一开始为100 当议会中 会出现支持和不支持以及摇摆 

#以下三个值均为三股不同力量士族可以篡改的值 其中士族可以把控群众支持度，商贾可以把控金钱，丹阳派系的军官可以把控劳动力
var people_surrport #群众支持度 数值
var  coin #金钱 数值
var labor_force #劳动力 可以当作军队进行使用 劳动力转换成军队需要消耗值 骑兵 步兵 弓兵




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
