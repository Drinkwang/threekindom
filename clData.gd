class_name cldata
extends Resource

@export var _name:String
@export var _num_all:int#总人数
@export var _num_rt:int #摇摆人数
@export var _num_sp:int #支持人数
@export var _num_op:int #反对人数
@export var _support_rate:int=100 #支持率
@export var isshow:bool=true 
@export var index:factionIndex

enum factionIndex{
	weidipai,
	bentupai,
	haozupai
	
}
