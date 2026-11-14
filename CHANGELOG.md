# Changelog

## [Unreleased]

### 新增

- **支援 Companion Dogs 的狼**：Companion Dogs 0.9.0 加入會攻擊玩家的狼。啟用 Companion Dogs 時，動物物種篩選多一格「狼（附近已載入）」，可以單獨開關；符號風格用狼頭符號，彩圖風格用彩色狼圖。之前狼和不認得的動物一樣只畫成腳印，也關不掉。和狗一樣，要先開主 MOD 的動物圖標，而且只顯示附近已載入的狼。Companion Dogs 還沒更新到 0.9.0 時，篩選會多這一格但沒有狼可顯示。

> 技術要點：`registerAnimalGroup` 多登記 group `wolf`（Mod ID 仍是 `CompanionDogs`），符號 `media/ui/MinidoracatMiniMapCompat/map_wolf.png`、彩圖 `media/textures/Item_MinidoracatMiniMapCompat_Wolf.png`，兩張都是本包自製。登記順序是狗、狼、馬。

## [42.21.0-0.4.0] - 2026-11-08

### 新增

- **支援 Bandits 與 Project A-Life 的 NPC 換色**（玩家建議）：這兩個 MOD 的 NPC 在小地圖和世界地圖上原本和殭屍一樣是橘點，現在改用各自的顏色（預設 Bandits 天藍、Project A-Life 綠；只啟用其中一個時它是天藍），畫在殭屍點上面。要開主 MOD 的「在小地圖顯示殭屍點位」才看得到；顏色在地圖顯示設定的「殭屍」分類逐一調整。需要主 MOD 支援 NPC 換色的新版，請兩個 MOD 都更新後重開遊戲。主 MOD 太舊時 NPC 照殭屍色顯示，狗與馬的支援照常。沒啟用 Bandits 或 Project A-Life 時不會有任何變化。
- **支援 Dynamic Outposts 的前哨站與感染點**（玩家建議）：你在世界地圖上看得到的前哨站（走近發現過、伺服器設定全部顯示，或你有權限的已佔領前哨站）現在也畫在小地圖，圖示依物資類型，底色和它的世界地圖一樣（一般米色、已佔領綠、強盜佔據紅）；作用中的感染點畫成紅框骷髏。世界地圖照舊用 Dynamic Outposts 自己的圖示；它的選項「Show outpost map icons」關掉時，小地圖也不畫。單機與多人都可用。
- **支援 Random Airdrops HF 的空投**（玩家建議）：飛機投下空投後，落點在小地圖與世界地圖畫成黃框空投圖示並寫「空投」，空投被移除後標記跟著消失。只在單機有效（這個 MOD 本身不支援多人）；讀檔前投下的空投，讀檔後不再顯示。

> 技術要點：本包在檔案載入時向主 MOD 的 `registerNpcTag`（`npcApiVersion` 1 以上）登記兩個 tag，依序 `bandits`（變數 `Bandit`，Mod ID `Bandits2`）、`alife`（變數 `ALifeActor`，Mod ID `ProjectALifeNPCs`），只登記動畫變數名稱。前哨站與空投經主 MOD 的 `registerMarkerProvider`（`markerApiVersion` 1 以上）畫：Dynamic Outposts（Mod ID `claimableoutposts_dynamic_hordes`）照它自己的顯示規則讀它在客戶端的前哨站資料；Random Airdrops HF（Mod ID `RandomAirdropsHF`）在進入遊戲時包住 `RandomAirdrops.FlyOver` 記下落點，原函式照原樣呼叫。這兩個讀的是對方的內部資料，依賴的名稱登記在 GitHub repo 的 `upstream.json`，每天比對 Steam 上游，對不上時本包不畫、只在遊戲紀錄檔留一行。所有支援的 MOD 都是選用依賴，不在 `require=`。

## [42.21.0-0.3.2] - 2026-10-27

### 修正

- **遊戲內 MOD 清單看不到本 MOD 的封面圖**：從 0.2.1 起，MOD 清單裡本 MOD 的封面一直是空白，遊戲紀錄檔還會多出一條錯誤訊息。現在 MOD 清單會正常顯示封面，錯誤訊息也不會再出現。相容功能沒有受影響，更新後不用做任何設定。

## [42.21.0-0.3.1] - 2026-10-11

### 變更

- 主 MOD（小地圖）版本太舊、缺少相容包需要的功能時，寫進遊戲紀錄檔的提示訊息改為英文。功能沒有變動。

## [42.21.0-0.3.0] - 2026-10-09

### 新增

- **介面新增 8 種語言**：韓文、俄文、西班牙文、葡萄牙文、土耳其文、法文、波蘭文、德文。遊戲語言選這些語言時，本 MOD 的介面、選項與提示會跟著顯示該語言（西班牙文同時用於阿根廷、智利、墨西哥，葡萄牙文同時用於葡萄牙）。翻譯有問題請回報。更新後重開遊戲生效。

## [42.21.0-0.2.1] - 2026-09-29

### 變更

- 對應遊戲 42.21.0：已確認相容包在 42.21.0 正常運作，功能沒有變動。
- 說明文字的遊戲版本需求改為「跟隨主 MOD」（目前需 Build 42.21.0 以上）；本包自身的最低版本沒有提高，
  實際能玩的最低版本由主 MOD 決定。

## [42.19.0-0.2.0] - 2026-07-15

### 新增

- 支援 Horse Mod（Workshop `3661336777`）：將 `horse` 群組加入主 MOD 動物物種篩選。
- 加入自製的馬符號、彩色馬圖與彩色狗圖；不包含任何第三方 MOD 素材。
- 本機掛載與 no-steam 伺服器 `Mods=` 流程加入 `Horse`，卸載時可選擇連同兩個上游 MOD 一併移除。

## [42.19.0-0.1.0] - 2026-07-15

### 新增

- 建立獨立的第三方 MOD 相容包專案，必要依賴為 `MinidoracatMiniMapFor42`。
- 首個 adapter 支援 Companion Dogs [ALPHA]（Workshop `3740052292`）：啟用時將 `dog`
  群組加入主 MOD 動物物種篩選，並使用遊戲原版爪印圖標。
- 四語物種標籤（繁中、簡中、英文、日文）。
- 加入 Lua 回歸測試、本機 Workshop／mods 掛載工具，以及 no-steam 伺服器 `Mods=` 管理。
- 卸載工具可選擇一併移除 `CompanionDogs` 的 mods 連結與伺服器 ID，預設仍只移除相容包。
