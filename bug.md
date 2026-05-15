# 带 {{...}} 和 [voice:] 的对话行（翻译会失败）

这些行同时包含 `{{...}}` 模板表达式和 `[voice:]` 配音标记，会导致翻译失败。

原因：`translate()` 第一次 `tr()` 因 `[voice:]` 匹配不上 CSV key，而 `dialogue_label` 第二次自动 `tr()` 时 `{{...}}` 已被替换为实际值，也匹配不上。

---

## 屋舍.dialogue

### Line 113
```
{{GameManager.resideValue}}[voice:zhubo_darenruzhangpofeng]
```
- CSV 中无对应条目

### Line 604
```
主簿: 主公，本月各派俸禄，糜竺先生已按旧例足额自行发放，共耗费{{determineDetail}}，各部皆无异议，军心安定。您获得{{GameManager.getLawPoint}}点政策点数。[voice:zhubo_shouhuodianshu]
```
- CSV 中有对应条目（key 不含 `[voice:]`），但运行时因 `[voice:]` 导致匹配失败

## 演武场.dialogue

### Line 587
```
部将 : 禀主公！今日张将军从徐州发来：\n- 军饷{{GameManager.sav.coin_DayGet}}贯\n- 新募士兵{{GameManager.sav.labor_DayGet}}人[voice:qinbin_junxiang]
```
- 同样会因 `[voice:]` + `{{...}}` 导致翻译失败
