# Changelog

## [42.19.0-0.1.0] - 2026-07-15

### 新增

- 建立獨立的第三方 MOD 相容包專案，必要依賴為 `MinidoracatMiniMapFor42`。
- 首個 adapter 支援 Companion Dogs [ALPHA]（Workshop `3740052292`）：啟用時將 `dog`
  群組加入主 MOD 動物物種篩選，並使用遊戲原版爪印圖標。
- 四語物種標籤（繁中、簡中、英文、日文）。
- 加入 Lua 回歸測試、本機 Workshop／mods 掛載工具，以及 no-steam 伺服器 `Mods=` 管理。
- 卸載工具可選擇一併移除 `CompanionDogs` 的 mods 連結與伺服器 ID，預設仍只移除相容包。
