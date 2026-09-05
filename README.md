# Minidoracat MiniMap - MOD Compatibility for B42

**By Minidoracat**

[Minidoracat MiniMap for B42](../MinidoracatMiniMapFor42) 的第三方 MOD 相容包。
每個 adapter 只把已確認的原版物件群組登記到主 MOD 的公開 API，提供有名稱、可個別開關的
物種篩選項；不複製第三方程式或素材，也不接管第三方 MOD 自己的地圖標記。本包只內含
自行製作的相容圖標。

## 目前支援

| 第三方 MOD | Workshop | Mod ID | 提供的相容功能 |
| --- | --- | --- | --- |
| Companion Dogs [ALPHA] | [3740052292](https://steamcommunity.com/sharedfiles/filedetails/?id=3740052292) | `CompanionDogs` | 將 `dog` 加入物種篩選；符號風格使用原版爪印，彩圖風格使用本包狗圖 |
| Horse Mod [B42.14+/MP SOON] | [3661336777](https://steamcommunity.com/sharedfiles/filedetails/?id=3661336777) | `Horse` | 將 `horse` 加入物種篩選；提供本包自製的馬符號與彩圖 |

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

## 安裝與依賴

- 必要：`MinidoracatMiniMapFor42`（`mod.info` 以 `require=` 保證先載入）。
- 選用：`CompanionDogs`、`Horse`。各自未啟用時安靜 no-op，不新增對應選項、不產生錯誤。
- Build 42.19.0+；單機與多人皆可用。多人伺服器需啟用主 MOD、第三方 MOD與本相容包。
- no-steam 本機伺服器的 `Mods=` 順序：
  `MinidoracatMiniMapFor42;CompanionDogs;Horse;MinidoracatMiniMapCompatFor42`。
- `link_workshop.bat` 卸載時可選擇一併移除 `CompanionDogs`、`Horse` 的 mods 連結與伺服器 ID；
  主 MOD與其他伺服器 MOD不會被移除。

## 為什麼獨立專案

主 MOD 維持通用的地圖與 `IsoAnimal` 顯示能力；第三方 MOD 的名稱、群組、測試與相容說明集中在
本專案。未來某個第三方 MOD 更新或移除時，可以單獨調整 adapter，不必把第三方耦合帶進
主 MOD。相容包本身仍保持資料導向：只有靜態群組登記與自有圖標，不需要 callback、provider
或額外繪製 hook。

## 專案結構

```text
MinidoracatMiniMapCompatFor42/
├── STEAM_DESCRIPTION*.md
├── STEAM_DISCUSSION_wishlist.md
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
        │   └── shared/Translate/{CH,CN,EN,JP}/UI.json
        ├── textures/Item_MinidoracatMiniMapCompat_{Dog,Horse}.png
        └── ui/MinidoracatMiniMapCompat/map_horse.png
```

## 測試

```powershell
luac -p MOD/MinidoracatMiniMapCompatFor42/Contents/mods/MinidoracatMiniMapCompatFor42/42/media/lua/client/MinidoracatMiniMapCompat.lua
lua scripts/test_companion_dogs_compat.lua
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test_link_workshop.ps1
python D:/github/MinidoracatMiniMapFor42/scripts/check_lua_bindings.py MOD/MinidoracatMiniMapCompatFor42/Contents/mods/MinidoracatMiniMapCompatFor42/42/media/lua/client/MinidoracatMiniMapCompat.lua
```

遊戲內測試前先執行 `link_workshop.bat`，再執行 `PZ_Test.bat`。Lua／翻譯改動後必須重啟遊戲。

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
