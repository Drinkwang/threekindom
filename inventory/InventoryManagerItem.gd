# List of creted items for InventoryManger to use in source code: MIT License
# @author Vladimir Petrenko
@tool
class_name InventoryManagerItem


enum ItemEnum { NONE,  益气丸, 胜战锦囊, 诸子百家论集, 珍品礼盒, 雌雄双股剑, 青龙偃月刀, 丈八蛇矛, 龙胆亮银枪, HelmetKnight, HelmetViking, ArmorKnight, ArmorViking, GlovesLeftKnight, GlovesLeftViking, GlovesRightKnight, GlovesRightViking, BootsKnight, BootsViking, ShieldKnight, ShieldViking, Gold2D, Metal2D, Horn2D, RecipeHelmetKnight2D, RecipeHelmetViking2D}

const 益气丸 = "f4352b3f-8500-419f-9617-9da134d822f5"
const 胜战锦囊 = "63015407-55c9-4729-887f-493fe2a624b7"
const 诸子百家论集 = "af0ab25b-4add-4834-ad96-555efd2e629d"
const 珍品礼盒 = "a9f24ca6-b213-4f07-a690-2185ffd6ec1d"
const 雌雄双股剑 = "cf240703-26ac-4a2a-88a7-1441ff6c6a0c"
const 青龙偃月刀 = "5fa70d8d-c0d0-43d9-8260-6efa4fde008b"
const 丈八蛇矛 = "52d0a7fa-b133-45f1-9b75-b9818c8599d2"
const 龙胆亮银枪 = "38a142cc-57cb-4f07-8e61-3b7c6601f3b8"
const HELMETKNIGHT = "8274191e-eaac-4605-9f3e-f55492b5a4b9"
const HELMETVIKING = "a20c35ce-bcc8-4344-9840-dc0783ebb2e4"
const ARMORKNIGHT = "677586f9-55cc-40c2-bd87-7c54430c629d"
const ARMORVIKING = "3b6f1acc-6616-4af8-aba3-0fe78c57da13"
const GLOVESLEFTKNIGHT = "8d1e1f40-99d4-4054-9891-af6342dab146"
const GLOVESLEFTVIKING = "4f73839a-9671-4ff0-94f7-8db09d3566a2"
const GLOVESRIGHTKNIGHT = "a71930cb-0732-4420-a182-7bbfd93b3d21"
const GLOVESRIGHTVIKING = "bf6722f3-fbeb-4929-904c-511daa8b120b"
const BOOTSKNIGHT = "e4b10f53-f1ef-437d-9d19-f877e7a7075c"
const BOOTSVIKING = "04c54b13-060a-452b-a5df-96b49d276cb1"
const SHIELDKNIGHT = "9802268f-f635-4469-8c6a-b12f0720da6a"
const SHIELDVIKING = "921213e4-4daf-4221-809b-2bfe4a69ccf1"
const GOLD2D = "f468cddf-638f-4b2f-9147-a1ceaa0f5c53"
const METAL2D = "424be528-8960-4c74-a96f-229724ebd870"
const HORN2D = "bbbbfd43-1f98-4b1a-bf3e-9f7383204803"
const RECIPEHELMETKNIGHT2D = "97b7c8ba-3c27-4158-9633-11dbd4fefd21"
const RECIPEHELMETVIKING2D = "73cbb965-26a5-4867-9849-9909c096641f"

const ITEMS = [
 "益气丸",
 "胜战锦囊",
 "诸子百家论集",
 "珍品礼盒",
 "雌雄双股剑",
 "青龙偃月刀",
 "丈八蛇矛",
 "龙胆亮银枪",
 "HelmetKnight",
 "HelmetViking",
 "ArmorKnight",
 "ArmorViking",
 "GlovesLeftKnight",
 "GlovesLeftViking",
 "GlovesRightKnight",
 "GlovesRightViking",
 "BootsKnight",
 "BootsViking",
 "ShieldKnight",
 "ShieldViking",
 "Gold2D",
 "Metal2D",
 "Horn2D",
 "RecipeHelmetKnight2D",
 "RecipeHelmetViking2D"
]

static func item_by_enum(item_enum: ItemEnum) -> String:
	match item_enum:
		ItemEnum.益气丸:
			return InventoryManagerItem.益气丸
		ItemEnum.胜战锦囊:
			return InventoryManagerItem.胜战锦囊
		ItemEnum.诸子百家论集:
			return InventoryManagerItem.诸子百家论集
		ItemEnum.珍品礼盒:
			return InventoryManagerItem.珍品礼盒
		ItemEnum.雌雄双股剑:
			return InventoryManagerItem.雌雄双股剑
		ItemEnum.青龙偃月刀:
			return InventoryManagerItem.青龙偃月刀
		ItemEnum.丈八蛇矛:
			return InventoryManagerItem.丈八蛇矛
		ItemEnum.龙胆亮银枪:
			return InventoryManagerItem.龙胆亮银枪
		ItemEnum.HelmetKnight:
			return InventoryManagerItem.HELMETKNIGHT
		ItemEnum.HelmetViking:
			return InventoryManagerItem.HELMETVIKING
		ItemEnum.ArmorKnight:
			return InventoryManagerItem.ARMORKNIGHT
		ItemEnum.ArmorViking:
			return InventoryManagerItem.ARMORVIKING
		ItemEnum.GlovesLeftKnight:
			return InventoryManagerItem.GLOVESLEFTKNIGHT
		ItemEnum.GlovesLeftViking:
			return InventoryManagerItem.GLOVESLEFTVIKING
		ItemEnum.GlovesRightKnight:
			return InventoryManagerItem.GLOVESRIGHTKNIGHT
		ItemEnum.GlovesRightViking:
			return InventoryManagerItem.GLOVESRIGHTVIKING
		ItemEnum.BootsKnight:
			return InventoryManagerItem.BOOTSKNIGHT
		ItemEnum.BootsViking:
			return InventoryManagerItem.BOOTSVIKING
		ItemEnum.ShieldKnight:
			return InventoryManagerItem.SHIELDKNIGHT
		ItemEnum.ShieldViking:
			return InventoryManagerItem.SHIELDVIKING
		ItemEnum.Gold2D:
			return InventoryManagerItem.GOLD2D
		ItemEnum.Metal2D:
			return InventoryManagerItem.METAL2D
		ItemEnum.Horn2D:
			return InventoryManagerItem.HORN2D
		ItemEnum.RecipeHelmetKnight2D:
			return InventoryManagerItem.RECIPEHELMETKNIGHT2D
		ItemEnum.RecipeHelmetViking2D:
			return InventoryManagerItem.RECIPEHELMETVIKING2D
		_:
			return ""