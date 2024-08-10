# ========================================================
# 名称：myNum
# 类型：静态函数库
# 简介：提供数字相关的处理函数
# 作者：巽星石
# Godot版本：v4.2.2.stable.official [15073afe3]
# 创建时间：2024年4月27日12:16:57
# 最后修改时间：2024年4月27日13:17:00
# ========================================================
class_name myNum

# ============================ 获取数字的位数 ============================
# 返回整数或浮点数的位数（不包含小数点）
static func get_length(num) -> int:
	if num is int:
		return str(num).length()
	elif num is float:
		return str(num).length() - 1
	else:
		return -1

# ============================ 判断类型 ============================
# 判断数字是否是整数
static func is_int(num) -> bool:
	return num is int

# 判断数字是否是浮点数
static func is_float(num) -> bool:
	return num is float

# ============================ 获取浮点数的整数或小数部分 ============================
# 获取浮点数的整数部分
static func get_float_int(num:float) -> int:
	return int(str(num).split(".")[0])

# 获取浮点数的小数部分
static func get_float_point_num(num:float) -> float:
	return float("0." + str(num).split(".")[1])

# ============================ 格式化显示 ============================
# 格式化显示
static func format(num,format:String) -> String:
	if num is int: # 整数，前面补0
		var fm = "%" + "0%dd" % format.length()
		return fm % num
	elif num is float:
		# 获取整数和小数部分
		var int_num    # 整数部分
		var point_num  # 小数部分
		
		if format.find(".") == -1: # 没有小数点
			int_num = str(num).split(".")[0]
			point_num = ""
			var fm1 = "%" + "0%dd" % format.split(".")[0].length()
			return fm1 % int(int_num)  # 返回格式化的整数部分
		elif format.find(".") == 0: # 没有设定整数格式
			int_num = str(num).split(".")[0]
			point_num = str(num).split(".")[1]
			var fm2 = "%" + "0-%dd" % [format.length()-1]
			return "%s.%s" % [int_num,fm2 % int(point_num)] 
		else:
			int_num = str(num).split(".")[0]
			point_num = str(num).split(".")[1]
			var fm1 = "%" + "0%dd" % format.split(".")[0].length()
			var fm2 = "%" + "0-%dd" % format.split(".")[1].length()
			# 格式化整数和小数部分
			int_num = fm1 % int(int_num)
			point_num = fm2 % int(point_num)
			# 返回完整字符串
			return "%s.%s" % [int_num,point_num] 
	else:
		return ""
