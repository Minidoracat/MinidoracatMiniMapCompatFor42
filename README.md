# Minidoracat MiniMap - MOD Compatibility

**By Minidoracat**

[Minidoracat MiniMap](../MinidoracatMiniMapFor42) 的第三方 MOD 相容包。
每個 adapter 只把已確認的資料登記到主 MOD 的公開 API：動物 MOD 登記原版物件群組，提供有名稱、
可個別開關的物種篩選項；NPC MOD 登記它掛在 NPC 身上的動畫變數，讓殭屍點位裡的 NPC 換成自己的顏色。
不複製第三方程式或素材，也不接管第三方 MOD 自己的地圖標記。本包只內含自行製作的相容圖標。

## 目前支援

| 第三方 MOD | Workshop | Mod ID | 提供的相容功能 |
| --- | --- | --- | --- |
| Companion Dogs [ALPHA] | [3740052292](https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292) | `CompanionDogs` | 將 `dog` 加入物種篩選；符號風格使用原版爪印，彩圖風格使用本包狗圖 |
| Horse Mod [B42.14+/MP SOON] | [3661336777](https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777) | `Horse` | 將 `horse` 加入物種篩選；提供本包自製的馬符號與彩圖 |
| [B42] Bandits NPC | [3268487204](https://steamcommunity.com/sharedfiles/filedetails/?id=3268487204) | `Bandits2` | 殭屍點位裡的 Bandits NPC 換成自己的顏色（預設天藍） |
| Project A-Life [ALIFE NPCS] | [3803984183](https://steamcommunity.com/sharedfiles/filedetails/?id=3803984183) | `ProjectALifeNPCs` | 殭屍點位裡的 A-Life NPC 換成自己的顏色（預設綠；只啟用它時是天藍） |

### Companion Dogs 的顯示行為

- Companion Dogs 原本的 active／passive companion marker 保持不變。
- 主 MOD 的野生／畜養動物圖標預設關閉，因此預設不會多畫一層泛用狗圖標。
- 玩家若開啟主 MOD 的畜養動物圖標，附近已載入且 `group=dog` 的狗會依圖標風格使用
  原版爪印或本包彩色狗圖顯示。
- 主 MOD 原本就會以爪印備援未知群組；本相容包新增的是經驗證的「狗」名稱與獨立篩選開關。
- 若只想保留 Companion Dogs 自己的 marker，可在主 MOD「動物圖標」物種篩選取消「狗」。
- `dog` 同時可能包含 companion 與 stray，因此本相容包不會擅自隱藏整個群組。

### Horse Mod 的顯示行為

- 啟用 Horse Mod 後，附近已載入且 `group=horse` 的馬會出現在獨立「馬」篩選項。
- 符號風格使用本包馬頭符號；彩圖風格使用本包彩色馬圖，未複製 Horse Mod 素材。
- 本包只顯示客戶端已載入的馬，不提供全地圖追蹤，也不改動馬的 AI、生成、裝備或騎乘。
- 相容包可用於多人，但 Horse Mod 目前 Workshop 標示 `MP SOON`，且明載騎乘尚未支援多人；
  本相容功能不會改變或繞過該限制。

### Bandits 與 Project A-Life 的顯示行為

- 這兩個 MOD 的 NPC 在遊戲裡是殭屍，主 MOD 的殭屍點位本來就會畫出它們（橘色，和殭屍一樣）。
  本包向主 MOD 登記兩者掛在 NPC 身上的動畫變數（Bandits `Bandit`、A-Life `ALifeActor`），
  主 MOD 讀到就改用該 MOD 的顏色，畫在殭屍點上面。
- 要看到 NPC 換色：主 MOD 的「在小地圖顯示殭屍點位」（預設關）要開；設定視窗「殭屍」分類的
  「NPC 用另一種顏色」預設開，每個 NPC MOD 一列「點顏色」可以改顏色。那個分類的說明行會寫出目前認得哪些 NPC MOD。
- 顯示距離、上限、掃描間隔都和殭屍點相同，看得到的範圍不會變大；伺服器沙盒「允許 NPC 點位換色」關閉時不分顏色。
- 需要主 MOD 支援 NPC 換色的版本（`npcApiVersion` 1 以上）；主 MOD 太舊時本包只在遊戲紀錄檔留一行提示，
  NPC 照殭屍色顯示，狗與馬的支援照常。
- 不做：Bandits 的據點、全地圖遊蕩隊、敵友分色。本包不讀兩個 MOD 的私有資料，也不呼叫它們的程式。

## 安裝與依賴

- 必要：`MinidoracatMiniMapFor42`（`mod.info` 以 `require=` 保證先載入）。
- 選用：`CompanionDogs`、`Horse`、`Bandits2`、`ProjectALifeNPCs`。各自未啟用時安靜 no-op，不新增對應選項、不產生錯誤。
- 遊戲版本跟隨主 MOD（目前需 Build 42.21.0 以上）；單機與多人皆可用。多人伺服器需啟用主 MOD、第三方 MOD與本相容包。
- no-steam 本機伺服器的 `Mods=` 順序：
  `MinidoracatMiniMapFor42;CompanionDogs;Horse;Bandits2;ProjectALifeNPCs;MinidoracatMiniMapCompatFor42`。
- `link_workshop.bat` 卸載只歸檔本相容包的受管副本，不移除主 MOD、CompanionDogs、Horse 或其他 MOD。

## 為什麼獨立專案

主 MOD 維持通用的地圖、`IsoAnimal` 與殭屍點位顯示能力；第三方 MOD 的名稱、群組、NPC 變數、測試與相容說明集中在
本專案。未來某個第三方 MOD 更新或移除時，可以單獨調整 adapter，不必把第三方耦合帶進
主 MOD。相容包本身仍保持資料導向：只有靜態的群組與 NPC 變數登記、自有圖標，不需要 callback、provider
或額外繪製 hook。

## 專案結構

```text
MinidoracatMiniMapCompatFor42/
├── STEAM_DESCRIPTION*.md
├── STEAM_DISCUSSION_guide*.md      # 說明＆許願串（繁中／EN）
├── STEAM_DISCUSSION_wishlist.md    # 舊許願串的指路文
├── link_workshop.bat
├── PZ_Test.bat
├── scripts/
│   ├── link_workshop.ps1
│   ├── PZ_Test.ps1
│   └── test_companion_dogs_compat.lua
└── MOD/MinidoracatMiniMapCompatFor42/Contents/mods/MinidoracatMiniMapCompatFor42/42/
    ├── mod.info
    └── media/
        ├── lua/
        │   ├── client/MinidoracatMiniMapCompat.lua
        │   └── shared/Translate/<16 個語系：AR,CH,CN,DE,EN,ES,ES_CL,ES_MX,FR,JP,KO,PL,PT,PTBR,RU,TR>/UI.json
        ├── textures/Item_MinidoracatMiniMapCompat_{Dog,Horse}.png
        └── ui/MinidoracatMiniMapCompat/map_horse.png
```

## 測試

```powershell
luac -p MOD/MinidoracatMiniMapCompatFor42/Contents/mods/MinidoracatMiniMapCompatFor42/42/media/lua/client/MinidoracatMiniMapCompat.lua
lua scripts/test_companion_dogs_compat.lua
python D:/github/MinidoracatMiniMapFor42/scripts/check_lua_bindings.py MOD/MinidoracatMiniMapCompatFor42/Contents/mods/MinidoracatMiniMapCompatFor42/42/media/lua/client/MinidoracatMiniMapCompat.lua
```

日常用 `PZ_Test.bat`，自動同步本包與家族依賴後才啟動；首次設定與資料保護見 `../pz-family-docs/tools.md`。Lua／翻譯改動後仍須重啟遊戲。工具回歸改用家族 `scripts/test_sync_mod.ps1`，不沿用舊連結專屬 API 測試。

### 發布到 Workshop

雙擊 `Publish_Workshop.bat`：先確認 Steam 用戶端已以作者帳號登入（未登入會喚起 Steam 並等你登入後重試），
再選擇更新 MOD 內容（含 `STEAM_CHANGELOG.md` 更新說明）／GIF 封面／簡介／全部；提交後回查 Steam，
任一不符即以非零碼結束。設定在 `scripts/workshop_publish.json`（Workshop ID、簡介語言槽來源、GIF 路徑）。

```
uv run --no-project python -B scripts/publish_workshop.py --mode all --yes       # 自動化／AI；或 content / preview / description
uv run --no-project python -B scripts/publish_workshop.py --mode all --dry-run   # 只檢查、顯示計畫
```

退出碼：`0` 成功／`2` 參數或取消／`3` 未登入、帳號不是擁有者／`4` 前置檢查失敗／`5` 提交失敗／`6` 已提交但回查不符。
網頁動態封面放 `MOD/<資料夾>/workshop/preview.gif`（不在 `Contents/`，不會下載給玩家）；遊戲內上傳器仍用 `preview.png`，
且每次會把網頁封面覆回靜態，需要動態封面時一律改用本工具發布。

## 授權

本專案自有程式碼、設定與圖標以 [MIT License](LICENSE) 釋出。Companion Dogs 與
[Horse Mod](https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777) 的程式及素材均不包含在
本專案內，權利與使用規範屬各自原作者；Horse Mod 仍是必要的原始內容來源。
