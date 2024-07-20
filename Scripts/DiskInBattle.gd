extends Control

@export var datas:Array[TextureProgressBar]
# Called when the node enters the scene tree for the first time.
func _ready():
	#初始化其中一个，然后随机获取一个
	var cloneData=datas.duplicate()
	var initValue:int=-1
	while cloneData.size()>0:
		var item:TextureProgressBar=cloneData.pick_random();
		if initValue==-1:
			initValue=randi_range(0,360)
		else:
			initValue=initValue+90
		item.radial_initial_angle=initValue
		item.radial_fill_degrees=90
		cloneData.remove_at(cloneData.find(item))

		
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
