# pokemon_sleep_tools

注意

因資料來源，此 App 不能放廣告或其他營利行為

## Develop

```shell
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Generating docs
fvm dart doc .
# Viewing docs
fvm dart pub global activate dhttpd
fvm dhttpd --path doc/api
```

Overview TODO (粗略完成即可，深層頁面不用非常完整):

- [x] 寶可夢圖鑑
- [ ] 個體分析
- [x] 地圖、睡姿
- [ ] 製作料理
- [x] 食譜一覽
  料理一覽 (用「料理類型、鍋子容量、食材」篩選、可以設定食譜等級計算顯示) -> 料理詳細頁面
  料理詳細頁面 (食材反查 -> 連結到食材詳細頁面 (可以設定寶可夢和食譜等級計算資訊、顯示擁有對應食材1的寶可夢、應該也可以取得寶可夢盒食材2,3的資訊))
- [x] 樹果
- [x] 食材
  食材一覽 -> 食材詳細頁面 （食材對應的料理 -> 料理反查（顯示料理的資訊）-> 料理詳細頁面）
- [ ] 隊伍 (寶可夢盒、隊伍分析、自動組隊)
- [x] 其他
    - [x] 鍋子
    - [x] 性格
    - [x] 主技能
    - [x] 副技能
- [x] 道具
- [x] 寶可夢經驗計算

TODO:

- 比較不同寶可夢數值 （BasicProfile 或是 Profile 各項數值互相比較）
- 因為反查功能很多，避免過多路由，在路由超過一定數量，Global 顯示按鈕用以 pop 到最上層?
- 可以自訂萌綠之島的卡比獸喜愛樹果，並且可以作用於整個 App (包含搜尋寶可夢等)
- 寶可夢隊伍可以新增標籤（例如是為了什麼）、可以新增自訂筆記

## 參考

參考：【攻略】使用能量計算!!更科學的『寶可夢Sleep潛力計算機v4.0』五段評價系統!!
連結：https://forum.gamer.com.tw/C.php?bsn=36685&snA=913
許可：歡迎轉傳至各論壇使用，請附上來源，本文及計算機禁止內容農場網站及Youtube等...任何營利目的使用。

參考：【攻略】食材寵認知革命 - 食譜進階觀念篇
連結：https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14342
許可：本文來自非營利社群「食神攻略組」多人共同討論製作，使用創用CC授權，轉載引用請告知
狀態：等待許可
