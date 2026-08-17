extends Node


const STATE_NAMES := {
	1: {
		1: "安定",
		2: "浮动",
		3: "紧张",
		4: "危急",
	},
	2: {
		1: "固若金汤",
		2: "布防仓促",
		3: "整备不足",
		4: "防备松弛",
		5: "军令未下",
	},
}

func get_state_name(state_group: int, state_id: int) -> String:
	var group_states: Dictionary = STATE_NAMES.get(state_group, {})
	var state_name := str(group_states.get(state_id, ""))

	if state_name.is_empty():
		push_warning("Unknown stage state: group=%s, id=%s" % [state_group, state_id])
		return tr("未知状态")

	return tr(state_name)
