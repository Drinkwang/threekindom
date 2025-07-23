class_name cldata
extends Resource

@export var _name:String=""
	#get:
		#return tr(_name)
	#set(value):
		#if _name.length()==0:
			#_name=value
		#else:
			#pass
@export var _num_all:int#总人数
@export var _num_rt:int #摇摆人数
@export var _num_sp:int #支持人数
@export var _num_op:int #反对人数
@export var _num_grain:int#分配的粮食
@export var _num_defections:int=0
@export var rebellionUpdateNum:int=0
@export var isAlertRisk=false
@export var isrebellion:bool=false
@export var isSuppressed=false
@export var _support_rate:int=100 #支持率
@export var isshow:bool=true 
@export var index:factionIndex
@export var isDoneOp=false
enum factionIndex{
	weidipai,
	bentupai,
	haozupai,
	lvbu
	
}

func getTr():
	return tr(_name)

func ChangeAllPeople(num):
	_num_all=_num_all+num
	if _num_all>100:
		_num_all=100
	elif _num_all<0:
		_num_all=0
	#发送信号

func ChangeSupport(num):
	_support_rate=_support_rate+num
	if _support_rate>100:
		_support_rate=100
	elif _support_rate<0:
		_support_rate=0
	#发送信号	
	SignalManager.changeFraction.emit()
