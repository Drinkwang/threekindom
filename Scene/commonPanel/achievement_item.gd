extends Control
class_name achiClass
@onready var context: Label = $context


@onready var lock_animated_sprite_2d: AnimatedSprite2D = $lock/AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@onready var succuss: TextureRect = $TextureRect/succuss
@onready var reward: TextureRect = $TextureRect/reward
@onready var discard: TextureRect = $TextureRect/discard

@export var lstate:lockState
@onready var lock: ColorRect = $lock
@onready var link: Sprite2D = $lock/Link
@onready var link_2: Sprite2D = $lock/Link2

@onready var color_rect: ColorRect = $ColorRect2


# 锁定，解锁，关闭，领取奖励，领取过
func changeState(state):
	lstate=state
	if lstate==lockState.lock:
		lock.show()
		TooltipManager.register_tooltip(color_rect,tr("该成就未解锁"))
		
		succuss.hide()
		reward.hide()
		discard.hide()		
		
	elif lstate==lockState.unlock:
		lock_animated_sprite_2d.play("new_animation")
		var _func=func(stringname):
			var tween=create_tween()
			tween.tween_property(link, "self_modulate:a",0,1)	
			tween.tween_property(link_2, "self_modulate:a",0,1)
			var _func2=func(stringname):
				changeState(lockState.close)
				#link.hide()
				#link_2
			tween.tween_callback(_func2)

		lock_animated_sprite_2d.animation_finished.connect(_func)
		#播放音效
		#播完执行tween 动画，播放锁链拉升声音，tween 动画完切状态

		
	elif lstate==lockState.close:
		TooltipManager.register_tooltip(discard,tr("该成就未完成，请在指定模式按照要求完成成就"))
		lock.hide()
		succuss.hide()
		reward.hide()
		discard.show()
	elif lstate==lockState.canReward:
		lock.hide()
		succuss.hide()
		reward.show()
		discard.hide()
		var coin=_data.coinGet
		var people=_data.peopleGet
		
		var context
		if coin>0 and people>0:
			context=tr("点击领取成就将获得{coins}钱 和{peoples}士兵").format({"coins":coin,"peoples":people})
		if coin>0 and people<=0:
			context=tr("点击领取成就将获得{coins}钱").format({"coins":coin})
		else:
			context=tr("点击领取成就将获得{peoples}士兵").format({"peoples":people})
		TooltipManager.register_tooltip(reward,context)
	elif lstate==lockState.after:
		#TooltipManager.register_tooltip(self,tr("该成就已完成"))
		lock.hide()
		succuss.show()
		reward.hide()
		discard.hide()
	
#{"enemy":"曹豹","level":"诡秘乱局","detail":"游戏结束时取得300分","holdcard":-1,"MaxUsecard":-1,"ScoreNum":300,"Mustkill":false,"iscom":0,"index":6,"coinGet":0,"peopleGet":120},
var _data

func initData(data):
	_data=data
	var num=InventoryManager.inventory_item_quantity(GameManager.inventoryPackege,InventoryManagerItem.玄阴玉符)
	


	if data.index>5 and num==0:
		changeState(lockState.lock)
	else:
		if data.iscom==0:
			changeState(lockState.close)
		elif data.iscom==1:
			changeState(lockState.canReward)
		elif data.iscom==2:
			changeState(lockState.after)
	context.text=tr(data.enemy)+"："+tr(data.level)+"\n"+tr(data.detail)
	
enum lockState{
	lock,
	unlock,
	close,
	canReward,
	after,
	
}




func _on_nine_patch_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:
		
		if lstate==lockState.canReward:
			var _reward:rewardPanel=PanelManager.new_reward()
			var items={
			"items": null,
			"money": _data.coinGet,
			"population": _data.peopleGet
			}
			
			_reward.showTitileReward(tr("恭喜你完成了成就"),items)
			
			
			changeState(lockState.after)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index==1:
		
		if lstate==lockState.canReward:
			var _reward:rewardPanel=PanelManager.new_reward()
			var items={
			"items": null,
			"money": _data.coinGet,
			"population": _data.peopleGet
			}
			_data.iscom=2
			_reward.showTitileReward(tr("恭喜你完成了成就"),items)
			
			
			changeState(lockState.after)
