# pokemon_sleep_tools

## Develop

```shell
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Overview TODO (粗略完成即可，深層頁面不用非常完整):

- [ ] 寶可夢圖鑑
- [ ] 個體分析
- [ ] 地圖、睡姿
- [ ] 製作料理
- [x] 食譜一覽
  料理一覽 (用「料理類型、鍋子容量、食材」篩選、可以設定食譜等級計算顯示) -> 料理詳細頁面
  料理詳細頁面 (食材反查 -> 連結到食材詳細頁面 (可以設定寶可夢和食譜等級計算資訊、顯示擁有對應食材1的寶可夢、應該也可以取得寶可夢盒食材2,3的資訊))
- [x] 樹果
- [x] 食材
  食材一覽 -> 食材詳細頁面 （食材對應的料理 -> 料理反查（顯示料理的資訊）-> 料理詳細頁面）
- [ ] 隊伍 (寶可夢盒、隊伍分析、自動組隊)
- [ ] 其他
    - [ ] 鍋子
    - [x] 性格
    - [x] 主技能
    - [x] 副技能
- [x] 道具
- [x] 寶可夢經驗計算

TODO:

- 比較不同寶可夢數值 （BasicProfile 或是 Profile 各項數值互相比較）
- 因為反查功能很多，避免過多路由，在路由超過一定數量，Global 顯示按鈕用以 pop 到最上層?

## 參考

參考

- [【攻略】使用能量計算!!更科學的『寶可夢Sleep潛力計算機v4.0』五段評價系統!!](https://forum.gamer.com.tw/C.php?bsn=36685&snA=913)
- https://pks.raenonx.cc
- [【心得】活力與寶可夢EXP機制相關研究（不定期更新）](https://forum.gamer.com.tw/C.php?bsn=36685&snA=612)
    餵食糖果給EXP下降的寶可夢得到80% 的經驗值
    餵食糖果給EXP上升的寶可夢得到120%的經驗值
- [【攻略】糖果計算機，自動算升級要準備幾顆糖](https://forum.gamer.com.tw/C.php?bsn=36685&snA=1045)
    萬能糖果S = 3顆
    萬能糖果M = 20顆    
    萬能糖果L = 100顆

