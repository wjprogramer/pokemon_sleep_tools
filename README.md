# pokemon_sleep_tools

- 平台：Windows, MacOS, Android, iOS (不考慮 Web!!)

注意

- 因資料來源，此 App 不能放廣告或其他營利行為
- 上架的時候需注意不能使用 assets/debug 下的資源，也要手動將 pubspec.yaml 的 assets/debug 刪掉

## 目標

- 讀取快速：因為過多的圖片，會導致線上版讀取較慢，因此只考慮離線版（也因此 App 檔案會有點大）；
  即便需要更新資料，也是透過網路下載資料後離線瀏覽
- 降低學習成本：透過與遊戲相似介面設計，使學習成本降低
- 整合資訊：搜集、理解後，盡量將遊戲所需知識都融合

## Develop 重要

- iOS 和 macOS 要將所有的 `D T_TOOLCHAIN_DIR` （去掉空白） 取代成 `TOOLCHAIN_DIR`

## Develop

```shell
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Generating docs
fvm dart doc .
# Viewing docs
fvm dart pub global activate dhttpd
fvm dhttpd --path doc/api
```

## Build

```shell
fvm flutter build windows
# \build\windows\x64\Release\Runner

fvm flutter build macos
```

---

## TODO

- 寶可夢進化鏈圖鑑
- 比較不同寶可夢數值 （BasicProfile 或是 Profile 各項數值互相比較）
  - 類似手機 plus, pro, pro max 詳細數據對比
- 因為反查功能很多，避免過多路由，在路由超過一定數量，Global 顯示按鈕用以 pop 到最上層?
- 寶可夢隊伍可以新增標籤（例如某個島嶼專用的隊伍）
- 寶可夢睡姿、異色圖片
  - 可以設定是否為異色
  - 顯示不同睡姿（分為異色與非異色）
- 主/副技能
  - 提供敘述
  - 反查功能盤點
- 圖鑑內反查寶可夢盒？
- 顯示盒內所有寶可夢的計算結果（評價）
- 計算器
  - 更新狼大新版計算器
  - 增加權重功能？
- 寶可夢
  - 可標記為「最愛、異色」
  - 排序（包含圖鑑及寶可夢盒）
  - 登錄日期：可讓使用者紀錄遊戲內實際捕獲的時間
- 搜尋寶可夢
  - 將功能加至寶可夢圖鑑
  - 搜尋寶可夢會出現的島嶼
  - 最終或目前進化階段查詢
  - 使用者自訂名稱
    - 使用者可以自訂寶可夢名稱
    - 關鍵字查詢可以查詢該欄位
- 共通搜尋
  - 儲存欄位條件？
    - 範圍：部分？全部？
    - 時機：最後一次搜尋（按下搜尋後）？手動？
- 排序寶可夢
- 資料 & 網路 & 更版
  - 資料放在 Github，透過網路請求更新寶可夢列表，避免需要一直手動上版
  - 資料：公告、更版訊息、更版判斷（最小支援）（網路上放的資料是否支援目前的 App）
  - FCM 推播？（成本？）
- 改用 ORM DB？
- 地圖
  - 畫面改善
  - 處理解鎖數量、百分比
- 處理 macOS release 問題（目前因 macOS 14 升版造成問題）
- 性格頁面
  - 反查寶可夢盒內的寶可夢？
- RWD
- 亮、暗主題
- 圖表
- 顯示目前寶可夢盒哪些食材、樹果無法搜集
- 之後圖片版本開發的差不多後，回頭修正文字版
  - 修正後上架？
- 開源
  - 評估是否可開源 
  - 改善程式碼後開源
  - 開源後，處理多國化
- CI/CD
  - Windows build apk/exe/... script
- 改 icon
- 進化道具頁面

### 桌面開發

- 支援滑鼠向前向後 (上一頁、下一頁)
  - [Feature Request: add fourth and fifth mouse button to Gesture detector](https://github.com/flutter/flutter/issues/115641)
  - [\[Desktop\] Navigate back with mouse back button](https://github.com/flutter/flutter/issues/56919)
  - 關鍵字: XBUTTON1 和 XBUTTON2
- 快捷鍵（例如圖鑑按上下可以選不同寶可夢）
- 
- 


### TODO (?)

- [ ] 個體分析
- [ ] 製作料理
- [ ] 隊伍 (寶可夢盒、隊伍分析、自動組隊)

## Notes

一些說明

- 聯繫繩進化，好友等級三的時候會贈送，繩子的數量會多到用不完，因此不建議浪費點數兌換。
- 寶可夢在進化過後可以提升一級的主動技能等級、五個持有上限，因此除非你的皮卡丘非常優質，否則還是建議大家，從皮丘開始培養。
-

## 參考

參考：【攻略】使用能量計算!!更科學的『寶可夢Sleep潛力計算機v4.0』五段評價系統!!
連結：https://forum.gamer.com.tw/C.php?bsn=36685&snA=913
許可：歡迎轉傳至各論壇使用，請附上來源，本文及計算機禁止內容農場網站及Youtube等...任何營利目的使用。

參考：【攻略】食材寵認知革命 - 食譜進階觀念篇
連結：https://forum.gamer.com.tw/Co.php?bsn=36685&sn=14342
許可：本文來自非營利社群「食神攻略組」多人共同討論製作，使用創用CC授權，轉載引用請告知

https://github.com/RaenonX-PokemonSleep/pokemon-sleep-ui
