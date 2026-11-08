-- MinidoracatMiniMapCompat.lua
-- 第三方 MOD 薄型 adapter：只向主 MOD 公開 API 登記已確認的 IsoAnimal group 與 NPC 標記（殭屍上的動畫變數）。

local OWN_MOD_ID = "MinidoracatMiniMapCompatFor42"
local api = MinidoracatMiniMapAPI
local missingApiLogged = false
local missingNpcApiLogged = false

local function isModActive(modId)
    local mods = getActivatedMods()
    for i = 1, mods:size() do
        if mods:get(i - 1) == modId then return true end
    end
    return false
end

local function registerIfActive(modId, group, labelKey, symbolPath, itemPath)
    if not isModActive(modId) then return end
    if api and api.registerAnimalGroup then
        api.registerAnimalGroup(OWN_MOD_ID, group, labelKey, symbolPath, itemPath)
    elseif not missingApiLogged then
        missingApiLogged = true
        print("[MinidoracatMiniMapCompat] registerAnimalGroup API missing; please update MinidoracatMiniMapFor42")
    end
end

-- registerNpcTag 有版本欄位（主 MOD docs/addon-api.md 3.20）：型別檢查＋>=，不用 ==（主 MOD 升 v2 時舊相容包照樣能登記）
local function registerNpcIfActive(modId, tag, labelKey, variable)
    if not isModActive(modId) then return end
    if api and type(api.npcApiVersion) == "number" and api.npcApiVersion >= 1
        and type(api.registerNpcTag) == "function" then
        api.registerNpcTag(OWN_MOD_ID, tag, labelKey, variable)
    elseif not missingNpcApiLogged then
        missingNpcApiLogged = true
        print("[MinidoracatMiniMapCompat] registerNpcTag API missing; NPC dots keep the zombie color, please update MinidoracatMiniMapFor42")
    end
end

registerIfActive("CompanionDogs", "dog", "UI_MinidoracatMiniMapCompat_Dog", nil,
    "media/textures/Item_MinidoracatMiniMapCompat_Dog.png")
registerIfActive("Horse", "horse", "UI_MinidoracatMiniMapCompat_Horse",
    "media/ui/MinidoracatMiniMapCompat/map_horse.png",
    "media/textures/Item_MinidoracatMiniMapCompat_Horse.png")
-- 登記順序決定主 MOD 的預設色（第 1 個天藍、第 2 個綠）
registerNpcIfActive("Bandits2", "bandits", "UI_MinidoracatMiniMapCompat_Bandits", "Bandit")
registerNpcIfActive("ProjectALifeNPCs", "alife", "UI_MinidoracatMiniMapCompat_ALife", "ALifeActor")
